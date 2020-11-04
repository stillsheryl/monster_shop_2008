require 'rails_helper'

RSpec.describe 'As a merchant employee', type: :feature do
  describe 'When I visit my merchant dashboard' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      kiera = @bike_shop.users.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password', role: 1)
      visit '/login'

      fill_in :email, with: kiera.email
      fill_in :password, with: kiera.password

      click_button 'Login'
    end

    it 'I see a link to view my own items when I click that link my URI route should be "/merchant/items"' do
      visit '/merchant'

      expect(page).to have_link("My Items")

      click_link "My Items"

      expect(current_path).to eq("/merchant/items")
    end
  end
end
