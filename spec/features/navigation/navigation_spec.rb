require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')

      within 'nav' do
        click_link 'Cart: '
      end

      expect(current_path).to eq('/cart')

      within 'nav' do
        click_link 'Register New User'
      end

      expect(current_path).to eq('/register')

      within 'nav' do
         click_link 'Home Page'
      end

      expect(current_path).to eq('/home')

      within 'nav' do
        click_link 'User Log In'
      end

      expect(current_path).to eq('/login')
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

    end
  end
  describe 'As a User' do
    it "shows same links as visitor plus profile page link and logout link" do
      kiera = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password')

      visit '/login'

      fill_in :email, with: kiera.email
      fill_in :password, with: kiera.password

      click_button 'Login'

      within 'nav' do
        expect(page).to have_link("#{kiera.name}'s Profile")
        expect(page).to have_link("Logout")
        expect(page).to_not have_link("User Log In")
        expect(page).to_not have_link("Register New User")
        expect(page).to have_content("Logged in as #{kiera.name}")
      end
    end
  end

  describe 'As a Merchant' do
    it "shows same links as users plus dashboard link" do
      kiera = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password', role: 1)

      visit '/login'

      fill_in :email, with: kiera.email
      fill_in :password, with: kiera.password

      click_button 'Login'
      save_and_open_page
      within 'nav' do
        expect(page).to have_link("Merchant's Dashboard")
      end
    end
  end
end
