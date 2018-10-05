module Features
  module SessionHelpers
    def sign_in
      @user = create :admin_user
      login
    end

    def regular_sign_in
      @user = create :user
      login
    end

    def login
      visit '/users/sign_in'
      fill_in 'Username', with: @user.username
      fill_in 'Password', with: @user.password
      click_button 'Sign in'
      @user
    end

    def sign_in_as(user)
      sign_out if @user
      @user = user
      login
    end

    # Sign out currently signed-in user through the UI
    def sign_out
      find('.navbar-right .dropdown-toggle').click
      click_link 'Log out'
      @user = nil
    end
  end
end

module Controllers
  module SessionHelpers
    def login_admin
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      @user = create :admin_user
      login
    end

    def login_user
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @user = create :user
      login
    end

    def login
      sign_in(@user, scope: :user)
      @user
    end
  end
end
