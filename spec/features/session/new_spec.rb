require "rails_helper"

# User Story 13, User can Login
#
# As a visitor
# When I visit the login path
# I see a field to enter my email address and password
# When I submit valid information

# If I am a regular user, I am redirected to my profile page
# If I am a merchant user, I am redirected to my merchant dashboard page
# If I am an admin user, I am redirected to my admin dashboard page
# And I see a flash message that I am logged in

describe "As a visitor" do
  describe "When I visit the login path" do
    describe "I see a field to enter my email address and password, when I submit valid information I am redirected based on my role and see a flash message that I am logged in" do
      it "As a regular user, I am redirected to my profile page" do
        kiera = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password')
        visit '/login'

        fill_in :email, with: kiera.email
        fill_in :password, with: kiera.password

        click_button 'Login'

        expect(current_path).to eq('/profile')
        expect(page).to have_content("Welcome #{kiera.name}!!!")
      end

      it "As a merchant user, I am redirected to my merchant dashboard page" do
        visit '/login'
      end

      it "As a admin user, I am redirected to my admin dashboard page" do
        visit '/login'
      end
    end
  end
end
