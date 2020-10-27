# User Story 10, User Registration
#
# As a visitor
# When I click on the 'register' link in the nav bar
# Then I am on the user registration page ('/register')
# And I see a form where I input the following data:
# - my name
# - my street address
# - my city
# - my state
# - my zip code
# - my email address
# - my preferred password
# - a confirmation field for my password
#
# When I fill in this form completely,
# And with a unique email address not already in the system
# My details are saved in the database
# Then I am logged in as a registered user
# I am taken to my profile page ("/profile")
# I see a flash message indicating that I am now registered and logged in

require 'rails_helper'

describe "as a visitor" do
  describe "When I click on the 'register' link in the nav bar" do
    it "On the user registration page ('/register') I can log in a new user and I'm taken to my '/profile' page" do
      visit '/register'

      fill_in :name, with: "Bob Marley"
      fill_in :address, with: "123 Main St."
      fill_in :city, with: "Denver"
      fill_in :state, with: "CO"
      fill_in :zip, with: "80205"
      fill_in :email, with: "bob@marley.com"
      fill_in :password, with: "password"
      fill_in :confirmation, with: "password"

      click_button "Register"

      expect(current_path).to eq("/profile")
      expect(page).to have_content("You are now registered and logged in.")
    end
  end
end
