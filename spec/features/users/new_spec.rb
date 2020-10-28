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
    it "will show an error message if the user does not fill out the form completely" do
      visit '/register'

      fill_in :address, with: "123 Main St."
      fill_in :city, with: "Denver"
      fill_in :state, with: "CO"
      fill_in :zip, with: "80205"
      fill_in :email, with: "bob@marley.com"
      fill_in :password, with: "password"
      fill_in :confirmation, with: "password"

      click_button "Register"

      expect(page).to have_content("Name can't be blank")
      expect(current_path).to eq('/register')
    end
  end
end
