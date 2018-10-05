feature User do
  context 'No sign in' do
  	scenario 'unauthorized_user cant log in' do
  		visit('/users/sign_in')
  		fill_in 'user_username', with: 'mcrispy'
  		fill_in 'user_password', with: 'slfkjlksjf'
  		click_button 'Sign in'
  		expect(page).to have_content 'Invalid Username or password.'

  	end
  end

  context 'Non-admin' do
    let!(:user) { regular_sign_in }
    let!(:target) { create(:target) }

    scenario 'cannot read users' do
      visit '/users'
      expect(page).to have_content 'You are not authorized to perform this action.'
    end

    scenario 'cannot destroy users' do
      expect(UserPolicy.new(user, User.new).destroy?).to be false
    end

    scenario 'can send message to helpdesk' do
      visit '/'
      click_link 'Help'
      expect(page).to have_selector("input[value='#{user.display_name}']")
      expect(page).to have_selector("input[value='#{user.email}']")

      fill_in 'Message', with: 'Help help help'
      expect { click_button 'Send' }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  context 'Admin' do
    let!(:user) { sign_in }
    let!(:reg_user) { create(:user) }

    before(:each) { visit '/users' }

    scenario 'can read users' do
      expect(find('tr', text: reg_user.display_name)).to have_content('Destroy')
      click_link reg_user.display_name
      expect(page).to have_content(reg_user.display_name)
    end

    scenario 'can destroy users' do
      expect(find('tr', text: reg_user.display_name)).to have_content('Destroy')
      within(find('tr', text: reg_user.display_name)) { click_link('Destroy') }
      expect(page).to have_content('User deleted')
    end

    scenario 'can update users' do
      visit '/users'
      within(find('tr', text: reg_user.display_name)) { click_button('Change Role') }
      expect(page).to have_content 'User updated'
      expect(page).to have_content 'Usage Data'
    end

  end

end