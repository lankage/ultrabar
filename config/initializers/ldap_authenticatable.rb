require 'net/ldap'
require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class LdapAuthenticatable < Authenticatable
      def authenticate!
        if params[:user]
          begin
            user = User.find_by(username: username, ldap: false)
            unless user
              ldap = Net::LDAP.new(
                host: Rails.configuration.ldap['host'],
                port: Rails.configuration.ldap['port'],
                base: Rails.configuration.ldap['base'],
                encryption: :simple_tls
              )
              ldap.auth "#{username}@#{Rails.configuration.ldap['domain']}", password
              # open connection to ldap
              filter = Net::LDAP::Filter.eq('sAMAccountName', username)

              if ldap.bind && (ldap_user = ldap.search(filter: filter).try(:first))
                # get local database user - initialize if not found
                # user_role = Role.find_by(name: 'User')
                user = User.find_or_initialize_by(username: username)
                user.update(
                  email: ldap_user.mail[0],
                  display_name: ldap_user.displayname[0],
                  first_name: ldap_user.givenname[0],
                  last_name: ldap_user.sn[0],
                  username: username,
                  password: password,
                  ldap: true
                )

                success!(user)
              else
                fail(:invalid_username)
              end
            end
          rescue Exception => e
            Rails.logger.info(e)
            ExceptionNotifier.notify_exception e, data: { message: "Error checking LDAP authentication" }
            fail(:invalid_login)
          end
        end
      end

      def username
        params[:user][:username]
      end

      def password
        params[:user][:password]
      end

    end
  end
end

Warden::Strategies.add(:ldap_authenticatable, Devise::Strategies::LdapAuthenticatable)
