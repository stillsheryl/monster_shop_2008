require 'rails_helper'
#
# User Story 16, User can log out
# Any items I had in my shopping cart are deleted

describe "As a registered user, merchant, or admin" do
  describe "When I click the logout button" do
    it "I am redirected to the home page and I see a flash message that I am logged out" do
      kiera = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password')

      visit '/login'

      fill_in :email, with: kiera.email
      fill_in :password, with: kiera.password

      click_button 'Login'

      page.driver.submit :delete, '/logout', {}

      expect(current_path).to eq('/home')
      expect(page).to have_content('You are now logged out.')
    end
    it "any items in my cart are deleted" do
      mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
      pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      kiera = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password')

      visit '/login'

      fill_in :email, with: kiera.email
      fill_in :password, with: kiera.password

      click_button 'Login'

      visit "/items/#{paper.id}"
      click_on "Add To Cart"

      page.driver.submit :delete, '/logout', {}

      save_and_open_page

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end
    end
  end
end
