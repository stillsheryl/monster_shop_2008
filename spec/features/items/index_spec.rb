require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "all items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
    end

    it "I can see a list of all of the active items, while the inactive items are not listed" do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

      expect(page).to_not have_link(@dog_bone.name)
      expect(page).to_not have_content(@dog_bone.description)
      expect(page).to_not have_content("Price: $#{@dog_bone.price}")
      expect(page).to_not have_content("Inactive")
      expect(page).to_not have_content("Inventory: #{@dog_bone.inventory}")
    end

    it "The item image is a link to that item's show page" do
      visit '/items'

      find("#link-#{@tire.id}").click
      expect(current_path).to eq("/items/#{@tire.id}")

      visit '/items'

      find("#link-#{@pull_toy.id}").click
      expect(current_path).to eq("/items/#{@pull_toy.id}")
    end
  end

  describe "When I visit the items index page" do
    before(:each) do
      @bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @dog_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @bell = @bike_shop.items.create!(name: "Silver Bell", description: "Let everyone know you're coming!", price: 25, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 10)
      @kickstand = @bike_shop.items.create!(name: "Kickstand", description: "Don't fall!", price: 75, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 4)
      @helmet = @bike_shop.items.create!(name: "Helmet", description: "Protect your head!", price: 150, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 20)
      @streamers = @bike_shop.items.create!(name: "streamers", description: "Everyone will see you coming!", price: 50, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 15)
      @seat = @bike_shop.items.create!(name: "Seat", description: "Protect your bum!", price: 90, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 7)

      @pull_toy = @dog_shop.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @dog_shop.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)
      @spring = @dog_shop.items.create!(name: "Spring Toy", description: "Best thing to chase", price: 7, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 53)
      @leash = @dog_shop.items.create!(name: "Leash", description: "Walk that dog!", price: 15, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 41)
      @octopus = @dog_shop.items.create!(name: "Plush Octopus Toy", description: "Your dog will love this thing", price: 32, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 12)

      # @user = create(:user)

      @order_1 = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 23455, user_id: @user.id)
      @order_2 = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 80203, user_id: @user.id)

      ItemOrder.create!(order_id: @order_1.id, price: 1.0, item_id: @dog_bone.id, quantity: 5)
      ItemOrder.create!(order_id: @order_1.id, price: 1.0, item_id: @pull_toy.id, quantity: 1)
      ItemOrder.create!(order_id: @order_1.id, price: 1.0, item_id: @tire.id, quantity: 4)
      ItemOrder.create!(order_id: @order_1.id, price: 1.0, item_id: @spring.id, quantity: 3)
      ItemOrder.create!(order_id: @order_1.id, price: 1.0, item_id: @leash.id, quantity: 2)
      ItemOrder.create!(order_id: @order_2.id, price: 1.0, item_id: @octopus.id, quantity: 3)
      ItemOrder.create!(order_id: @order_2.id, price: 1.0, item_id: @pull_toy.id, quantity: 4)
    end
    it "can see top 5 most popular items by quantity purchased, and quantity bought" do


      #   within top-five do
      #     expect(page).
      #   end
      #
      # item_order.quantity
      #
      # most_popular_ingredients from challenge
    end

    it "can see bottom 5 least items by quantity purchased, and quantity bought" do
    end
  end
end

# User Story 18, Items Index Page Statistics
#
# As any kind of user on the system
# When I visit the items index page ("/items")
# I see an area with statistics:
# - the top 5 most popular items by quantity purchased, plus the quantity bought
# - the bottom 5 least popular items, plus the quantity bought
#
# "Popularity" is determined by total quantity of that item ordered
