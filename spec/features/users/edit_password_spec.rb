require 'rails_helper'

# User Story 21, User Can Edit their Password
#
# As a registered user
# When I visit my profile page
# I see a link to edit my password
# When I click on the link to edit my password
# I see a form with fields for a new password, and a new password confirmation

# When I fill in the same password in both fields
# And I submit the form
# Then I am returned to my profile page
# And I see a flash message telling me that my password is updated
describe 'As a registered user' do
  describe 'When I visit my profile page' do
    before(:each) do
      @kiera = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password')

      visit '/login'

      fill_in :email, with: @kiera.email
      fill_in :password, with: @kiera.password

      click_button 'Login'
    end

    it 'I see a link to edit my password' do
      visit '/profile'

      expect(page).to have_link("Edit Password")
    end

    it 'When I click on the link I see a form for a new password, and a new password confirmation' do
      visit '/profile'
      click_link "Edit Password"

      expect(current_path).to eq('/profile/edit/password')
      expect(page).to have_field(:password)
      expect(page).to have_field(:password_confirmation)
    end

    it "When I fill it in with a new password then I am returned to my profile page and I see a flash message telling me that my password is updated" do
      visit '/profile/edit/password'

      fill_in :password, with: "newpassword"
      fill_in :password_confirmation, with: "newpassword"

      click_button "Update Password"

      expect(current_path).to eq('/profile')
      expect(page).to have_content('Your password has been updated.')
    end
  end
end
