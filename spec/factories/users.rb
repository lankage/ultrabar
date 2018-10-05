# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :integer
#  first_name             :string
#  last_name              :string
#  username               :string
#  display_name           :string
#  ldap                   :boolean
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

FactoryBot.define do
  factory :user, aliases: [:created_by] do
    first_name { Faker::Name.unique.first_name }
    last_name { Faker::Name.unique.last_name }
    display_name { first_name + ' ' + last_name }
    username { display_name.tr(' ', '_') }
    email { "#{username}@glbrc.org" }
    password 'secret'
    password_confirmation 'secret'

    factory :admin_user do
      email 'admin@glbrc.org'
      first_name 'Admin'
      last_name 'User'
      username 'admin'
      role 'admin'
      password 'mrcrispy!!'
      password_confirmation 'mrcrispy!!'
    end

    factory :unauthorized_user do
      email 'test@glbrc.org'
      first_name 'Mr'
      last_name 'Crispy'
      username 'mcrispy'
      password 'crispy'
      password_confirmation 'crispy'
    end

  end
end
