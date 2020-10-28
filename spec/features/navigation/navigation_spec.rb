# User Story 3, User Navigation
#
# As a default user
# I see the same links as a visitor
# Plus the following links
# - a link to my profile page ("/profile")
# - a link to log out ("/logout")
#
# Minus the following links
# - I do not see a link to log in or register
#
# I also see text that says "Logged in as Mike Dao" (or whatever my name is)

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
    it "shows all links plus profile page link and logout link" do

    end

  end
end
