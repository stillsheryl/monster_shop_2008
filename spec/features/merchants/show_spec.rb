require 'rails_helper'

RSpec.describe 'merchant show page', type: :feature do
  describe 'As a user' do
    before :each do
      @shop = create(:merchant)
    end

    it 'I can see a merchants name, address, city, state, zip' do
      visit "/merchants/#{@shop.id}"

      expect(page).to have_content(@shop.name)
      expect(page).to have_content(@shop.address)
    end

    it 'I can see a link to visit the merchant items' do
      visit "/merchants/#{@shop.id}"

      expect(page).to have_link("All #{@shop.name} Items")

      click_on "All #{@shop.name} Items"

      expect(current_path).to eq("/merchants/#{@shop.id}/items")
    end

  end
end
