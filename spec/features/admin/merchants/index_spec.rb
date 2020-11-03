# User Story 38, Admin disables a merchant account
#
# As an admin
# When I visit the admin's merchant index page ('/admin/merchants')
# I see a "disable" button next to any merchants who are not yet disabled
# When I click on the "disable" button
# I am returned to the admin's merchant index page where I see that the merchant's account is now disabled
# And I see a flash message that the merchant's account is now disabled

require 'rails_helper'

RSpec.describe "As an Admin visiting my Admin's Merchant Index page" do
  before(:each) do
    @bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @dog_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @fishing_shop = Merchant.create!(name: "Tim's Fishing Store", address: '127 Fish It Dr.', city: 'Denver', state: 'CO', zip: 80205)
    @cookie_shop = Merchant.create!(name: "Alex's Cookies and Treats", address: '128 Chip Ave.', city: 'Denver', state: 'CO', zip: 80211)
  end

  it "I see a 'disable' button next to any merchants not disabled" do
    @cookie_shop.update_attribute(:active?, false)

    visit "/admin/merchants"

      within "#merchant-#{@bike_shop.id}" do
        expect(page).to have_button("Disable")
        expect(page).to have_button("Enable")
      end

      within "#merchant-#{@dog_shop.id}" do
        expect(page).to have_button("Disable")
        expect(page).to have_button("Enable")
      end

      within "#merchant-#{@fishing_shop.id}" do
        expect(page).to have_button("Disable")
        expect(page).to have_button("Enable")
      end

      within "#merchant-#{@cookie_shop.id}" do
        expect(page).to_not have_button("Disable")
        expect(page).to have_button("Enable")
      end
  end

  it "When I click 'disable' I'm returned to '/admin/merchants' and that merchant is now disabled" do
  end

  it "I see a flash message that the merchant's account is now disabled" do
  end
end
