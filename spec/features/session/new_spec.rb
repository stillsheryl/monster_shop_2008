require "rails_helper"

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
        expect(page).to have_content("You are now logged in.")
      end

      it "As a merchant user, I am redirected to my merchant dashboard page" do
        bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
        sally = bike_shop.users.create!(name: 'Sally Peach', address: '432 Grove St.', city: 'Denver', state: 'CO', zip: 80205, email: 'sally@peach.com', password: 'password', role: 1)

        visit '/login'

        fill_in :email, with: sally.email
        fill_in :password, with: sally.password

        click_button 'Login'

        expect(current_path).to eq('/merchant')
        expect(page).to have_content("Welcome #{sally.name}!!")
        expect(page).to have_content("You are now logged in.")
      end

      it "As a admin user, I am redirected to my admin dashboard page" do
        bob = User.create!(name: 'Bob Ross', address: '745 Rose St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@ross.com', password: 'password', role: 2)

        visit '/login'

        fill_in :email, with: bob.email
        fill_in :password, with: bob.password

        click_button 'Login'

        expect(current_path).to eq('/admin')
        expect(page).to have_content("Welcome #{bob.name}!")
        expect(page).to have_content("You are now logged in.")
      end
    end
    describe "When I submit invalid login info" do
      it "redirects me to the log in page and I see a flash message" do
        kiera = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password')

        visit '/login'

        fill_in :email, with: "b0b@marley.com"
        fill_in :password, with: kiera.password

        click_button 'Login'

        expect(current_path).to eq('/login')
        expect(page).to have_content('Incorrect credentials, please try again.')
      end
    end
  end
  describe "As a user" do
    describe "who is logged in and tries to visit the login path" do
      it "I am redirected to my profile page" do
        kiera = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password')
        visit '/login'

        fill_in :email, with: kiera.email
        fill_in :password, with: kiera.password

        click_button 'Login'

        visit '/login'


        expect(current_path).to eq('/profile')
        expect(page).to have_content('You are already logged in.')
      end
    end
  end
  describe "As a merchant" do
    describe "who is logged in and tries to visit the login path" do
      it "I am redirected to my profile page" do
        bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
        sally = bike_shop.users.create!(name: 'Sally Peach', address: '432 Grove St.', city: 'Denver', state: 'CO', zip: 80205, email: 'sally@peach.com', password: 'password', role: 1)

        visit '/login'

        fill_in :email, with: sally.email
        fill_in :password, with: sally.password

        click_button 'Login'

        visit '/login'


        expect(current_path).to eq('/merchant')
        expect(page).to have_content('You are already logged in.')
      end
    end
  end
  describe "As an admin" do
    it "I am redirected to my profile page" do
      bob = User.create!(name: 'Bob Ross', address: '745 Rose St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@ross.com', password: 'password', role: 2)

      visit '/login'

      fill_in :email, with: bob.email
      fill_in :password, with: bob.password

      click_button 'Login'

      visit '/login'


      expect(current_path).to eq('/admin')
      expect(page).to have_content('You are already logged in.')
    end
  end
end
