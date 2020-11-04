require 'rails_helper'

RSpec.describe "As an Admin" do
  describe "When I visit my Admin's Merchant Index page" do
    before(:each) do
      @bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @dog_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @fishing_shop = Merchant.create!(name: "Tim's Fishing Store", address: '127 Fish It Dr.', city: 'Denver', state: 'CO', zip: 80205)
      @cookie_shop = Merchant.create!(name: "Alex's Cookies and Treats", address: '128 Chip Ave.', city: 'Denver', state: 'CO', zip: 80211)

      @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @bell = @bike_shop.items.create(name: "Silver Bell", description: "Let everyone know you're coming!", price: 25, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 10)
      @kickstand = @bike_shop.items.create(name: "Kickstand", description: "Don't fall!", price: 75, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 4)

      @spring = @dog_shop.items.create(name: "Spring Toy", description: "Best thing to chase", price: 7, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 53)
      @leash = @dog_shop.items.create(name: "Leash", description: "Walk that dog!", price: 15, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 41)
      @octopus = @dog_shop.items.create(name: "Plush Octopus Toy", description: "Your dog will love this thing", price: 32, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 12)

      @admin = User.create!(name: 'Bob Ross', address: '745 Rose St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@ross.com', password: 'password', role: 2)

      visit '/login'

      fill_in :email, with: @admin.email
      fill_in :password, with: @admin.password

      click_button 'Login'
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

    it "I click on 'Disable' button for a specific merchant and all their items are deactivated" do

      visit "/admin/merchants"

        within "#merchant-#{@bike_shop.id}" do
          click_button "Disable"
          expect(current_path).to eq("/admin/merchants")
          expect(page).to_not have_button("Disable")
          expect(page).to have_button("Enable")
        end

      visit "/items/#{@bell.id}"
      expect(page).to have_content("Inactive")

      visit "/items/#{@kickstand.id}"
      expect(page).to have_content("Inactive")

      visit "/items/#{@tire.id}"
      expect(page).to have_content("Inactive")

      visit "/items/#{@spring.id}"
      expect(page).to have_content("Active")
    end

    it "I see an 'Enable' button next to any disabled merchants" do

      @bike_shop.update_attribute(:active?, false)
      @fishing_shop.update_attribute(:active?, false)

      visit "/admin/merchants"

        within "#merchant-#{@bike_shop.id}" do
          expect(page).to_not have_button("Disable")
          expect(page).to have_button("Enable")
        end

        within "#merchant-#{@dog_shop.id}" do
          expect(page).to have_button("Disable")
          expect(page).to_not have_button("Enable")
        end

        within "#merchant-#{@fishing_shop.id}" do
          expect(page).to_not have_button("Disable")
          expect(page).to have_button("Enable")
        end

        within "#merchant-#{@cookie_shop.id}" do
          expect(page).to have_button("Disable")
          expect(page).to_not have_button("Enable")
        end
    end

    it "When I click 'Enable' I'm returned to '/admin/merchants' and that merchant is now enabled" do

      @bike_shop.update_attribute(:active?, false)

      visit "/admin/merchants"

      within "#merchant-#{@bike_shop.id}" do
        click_button "Enable"
      end

      expect(current_path).to eq("/admin/merchants")

        within "#merchant-#{@bike_shop.id}" do
          expect(page).to have_button("Disable")
          expect(page).to_not have_button("Enable")
        end
    end

    it "I see a flash message that the merchant's account is now enabled" do
      @bike_shop.update_attribute(:active?, false)

      visit "/admin/merchants"

        within "#merchant-#{@bike_shop.id}" do
          click_button "Enable"
        end

      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("#{@bike_shop.name} is enabled")
    end
  end
end
