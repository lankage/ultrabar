# user = CreateAdminService.new.call
# puts 'CREATED ADMIN USER: ' << user.email
include FactoryBot::Syntax::Methods

if Rails.env.development?
  print "Creating Users..."
  User.delete_all
  admin = create(:admin_user)
  puts 'Done'
elsif Rails.env.production?
  admin = create(:admin_user)
end
