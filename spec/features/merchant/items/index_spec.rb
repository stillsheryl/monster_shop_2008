require 'rails_helper'

RSpec.describe 'As a merchant employee', type: :feature do
  describe 'When I visit my items page' do
    before :each do
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      @leash = @dog_shop.items.create(name: "Leash", description: "Walk that dog!", price: 15, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 41)

      @kiera = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bobmarley.com', password: 'password')
      @order_1 = @kiera.orders.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, user_id: @kiera.id)
      @order_2 = @kiera.orders.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, user_id: @kiera.id)

      @item_order_1 = @order_1.item_orders.create!(item_id: @pull_toy.id, price: 4.50, quantity: 2)
      @item_order_2 = @order_1.item_orders.create!(item_id: @dog_bone.id, price: 7.00, quantity: 1)
      @item_order_3 = @order_2.item_orders.create!(item_id: @dog_bone.id, price: 7.00, quantity: 5)

      @sally = User.create!(name: 'Sally Peach', address: '432 Grove St.', city: 'Denver', state: 'CO', zip: 80205, email: 'sallypeach.com', password: 'password', role: 1, merchant_id: @dog_shop.id)

      visit '/login'

      fill_in :email, with: @sally.email
      fill_in :password, with: @sally.password

      click_button 'Login'
    end

    it "I see all of my items with their info" do
      visit '/merchant/items'

      within("#item-#{@pull_toy.id}") do
        expect(page).to have_content(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content(@pull_toy.price)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
        expect(page).to have_content("Status: Active")
        expect(page).to have_content(@pull_toy.inventory)
      end

      within("#item-#{@dog_bone.id}") do
        expect(page).to have_content(@dog_bone.name)
        expect(page).to have_content(@dog_bone.description)
        expect(page).to have_content(@dog_bone.price)
        expect(page).to have_css("img[src*='#{@dog_bone.image}']")
        expect(page).to have_content("Status: Inactive")
        expect(page).to have_content(@dog_bone.inventory)
      end
    end

    it "shows a button to deactivate the item next to each item that is active, and when I click on the 'deactivate' button I am returned to my items page and it shows a flash message indicating this item is no longer for sale and I see the item is now inactive" do
      visit '/merchant/items'

      find("#deactivate-#{@pull_toy.id}").click

      expect(current_path).to eq('/merchant/items')

      within("#item-#{@pull_toy.id}") do
        expect(page).to have_content("Status: Inactive")
      end

      expect(page).to have_content("Your item is now inactive and no longer for sale.")
    end

    it "shows a button to activate the item next to each item that is inactive, and when I click on the 'activate' button I am returned to my items page, I see a flash message indicating this item is now available for sale, and I see the item is now active" do
      visit '/merchant/items'

      find("#activate-#{@dog_bone.id}").click

      expect(current_path).to eq('/merchant/items')

      within("#item-#{@dog_bone.id}") do
        expect(page).to have_content("Status: Active")
      end

      expect(page).to have_content("Your item is now active and is now available for sale.")
    end

    it "has a button to delete the item next to each item that has never been ordered. When I click it I am returned to my items page, I see a flash message indicating this item is now deleted, I no longer see this item on the page" do
      visit '/merchant/items'

      expect(page).to have_content(@leash.name)

      within("#item-#{@pull_toy.id}") do
        expect(page).to_not have_button("Delete")
      end

      find("#delete-#{@leash.id}").click

      expect(current_path).to eq('/merchant/items')

      within(".grid-container") do
        expect(page).to_not have_content(@leash.name)
      end

      expect(page).to have_content("Your #{@leash.name} item has been deleted.")
    end

    it "I see a link to add a new item, and when I submit valid information and submit the form I am taken back to my items page and I see the item's info, a flash message indicating my new item is saved, and the new item is enabled and available for sale" do
      visit '/merchant/items'

      click_on "Add a New Item"

      name = "Squeaker Pup"
      description = 'This squeak will entertain your pup for hours!'
      image = "https://images.unsplash.com/photo-1529016011223-8ee9873aef1d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=658&q=80"
      price = 5.00
      inventory = 18

      fill_in :name, with: name
      fill_in :description, with: description
      fill_in :image, with: image
      fill_in :price, with: price
      fill_in :inventory, with: inventory

      click_button "Create Item"

      expect(current_path).to eq('/merchant/items')

      expect(page).to have_content(name)
      expect(page).to have_content(description)
      expect(page).to have_css("img[src*='#{image}']")
      expect(page).to have_content(price)
      expect(page).to have_content(inventory)
      expect(page).to have_content("Status: Active")

      expect(page).to have_content("Your new item has been saved and is now active and available for sale.")
    end

    it "I see a placeholder image for the thumbnail if I left the image field blank" do
      visit '/merchant/items'

      click_on "Add a New Item"

      name = "Squeaker Pup"
      description = 'This squeak will entertain your pup for hours!'
      price = 5.00
      inventory = 18

      fill_in :name, with: name
      fill_in :description, with: description
      fill_in :price, with: price
      fill_in :inventory, with: inventory

      click_button "Create Item"

      item_id = Item.last.id

      expect(current_path).to eq('/merchant/items')

      within("#item-#{item_id}") do
        expect(page.find("#image")['src']).to have_content("https://thumbs.dreamstime.com/z/no-image-available-icon-photo-camera-flat-vector-illustration-132483097.jpg")
      end
    end

    it "When I try to add a new item, if any of my data is incorrect or missing (except image) then I am returned to the form and I see one or more flash messages indicating each error I caused" do

      visit '/merchant/items'

      click_on "Add a New Item"

      name = "Squeaker Pup"
      description = 'This squeak will entertain your pup for hours!'
      price = 5.00
      inventory = 18

      fill_in :description, with: description
      fill_in :price, with: price
      fill_in :inventory, with: inventory

      click_button "Create Item"

      expect(page).to have_content("Name can't be blank")

      fill_in :name, with: name
      fill_in :description, with: nil
      fill_in :price, with: price
      fill_in :inventory, with: inventory

      click_button "Create Item"

      expect(page).to have_content("Description can't be blank")
    end
    it "must have a price greater than 0" do
      visit '/merchant/items'

      click_on "Add a New Item"

      name = "Squeaker Pup"
      description = 'This squeak will entertain your pup for hours!'
      price = 0.00
      inventory = 18

      fill_in :name, with: name
      fill_in :description, with: description
      fill_in :price, with: price
      fill_in :inventory, with: inventory
      click_button "Create Item"

      expect(page).to have_content("Price must be greater than 0")
    end
    it "must have an inventory count of zero or more" do
      visit '/merchant/items'

      click_on "Add a New Item"

      name = "Squeaker Pup"
      description = 'This squeak will entertain your pup for hours!'
      price = 2.00
      inventory = -1

      fill_in :name, with: name
      fill_in :description, with: description
      fill_in :price, with: price
      fill_in :inventory, with: inventory

      click_button "Create Item"

      expect(page).to have_content("Inventory must be greater than -1")
    end
    it "form is prepopulated after reloading" do
      visit '/merchant/items'

      click_on "Add a New Item"

      name = "Squeaker Pup"
      description = 'This squeak will entertain your pup for hours!'
      price = 0
      inventory = 18

      fill_in :name, with: name
      fill_in :description, with: description
      fill_in :price, with: price
      fill_in :inventory, with: inventory
      click_button "Create Item"

      expect(find_field('Name').value).to eq name
      expect(find_field('Description').value).to eq description
      expect(find_field('Price').value).to eq price.to_s
      expect(find_field('Inventory').value).to eq inventory.to_s
    end
  end
end
