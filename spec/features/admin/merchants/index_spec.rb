require 'rails_helper'

RSpec.describe "As an Admin" do
  describe "When I visit my Admin's Merchant Index page" do
    before(:each) do
      @bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @dog_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @fishing_shop = Merchant.create!(name: "Tim's Fishing Store", address: '127 Fish It Dr.', city: 'Denver', state: 'CO', zip: 80205)
      @cookie_shop = Merchant.create!(name: "Alex's Cookies and Treats", address: '128 Chip Ave.', city: 'Denver', state: 'CO', zip: 80211)
    end

    it "I see a 'Disable' button next to any merchants not disabled" do

      visit "/admin/merchants"

        within "#merchant-#{@bike_shop.id}" do
          expect(page).to have_button("Disable")
          expect(page).to_not have_button("Enable")
        end

        within "#merchant-#{@dog_shop.id}" do
          expect(page).to have_button("Disable")
          expect(page).to_not have_button("Enable")
        end

        within "#merchant-#{@fishing_shop.id}" do
          expect(page).to have_button("Disable")
          expect(page).to_not have_button("Enable")
        end

        within "#merchant-#{@cookie_shop.id}" do
          expect(page).to have_button("Disable")
          expect(page).to_not have_button("Enable")
        end
    end

    it "When I click 'Disable' I'm returned to '/admin/merchants' and that merchant is now disabled" do

      visit "/admin/merchants"

        within "#merchant-#{@bike_shop.id}" do
          click_button "Disable"
        end

      expect(current_path).to eq("/admin/merchants")

        within "#merchant-#{@bike_shop.id}" do
          expect(page).to_not have_button("Disable")
          expect(page).to have_button("Enable")
        end
    end

    it "I see a flash message that the merchant's account is now disabled" do

      visit "/admin/merchants"

      within "#merchant-#{@dog_shop.id}" do
        click_button "Disable"
      end

      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("#{@dog_shop.name} is disabled")
    end
  end
end
