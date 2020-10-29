require 'rails_helper'
#
# User Story 16, User can log out
#
# As a registered user, merchant, or admin
# When I visit the logout path
# I am redirected to the welcome / home page of the site
# And I see a flash message that indicates I am logged out
# Any items I had in my shopping cart are deleted

describe "As a registered user, merchant, or admin" do
  describe "When I click the logout button" do
    it "I am redirected to the home page and I see a flash message that I am logged out" do
      kiera = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password')

      visit '/login'

      fill_in :email, with: kiera.email
      fill_in :password, with: kiera.password

      click_button 'Login'

      visit '/logout'

      expect(current_path).to eq('/home')
      expect(page).to have_content('You are now logged out.')
    end
  end
end
