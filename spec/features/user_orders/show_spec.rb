require 'rails_helper'

describe "As a registered user" do
  describe "When I visit my order's show page, such as '/profile/orders/15'" do
    before :each do
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

      @kiera = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password')
      @order_1 = @kiera.orders.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, user_id: @kiera.id)
      @order_2 = @kiera.orders.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, user_id: @kiera.id)

      @item_order_1 = @order_1.item_orders.create!(item_id: @pull_toy.id, price: 4.50, quantity: 2)
      @item_order_2 = @order_1.item_orders.create!(item_id: @dog_bone.id, price: 7.00, quantity: 1)
      @item_order_3 = @order_2.item_orders.create!(item_id: @dog_bone.id, price: 7.00, quantity: 5)
    end

    it "I see all information about the order" do
      visit '/login'
      fill_in :email, with: @kiera.email
      fill_in :password, with: @kiera.password
      click_button 'Login'

      visit "/profile/orders/#{@order_1.id}"

      expect(page).to have_content(@order_1.id)
      expect(page).to_not have_content(@order_2.id)

      expect(page).to have_content(@order_1.created_at)
      expect(page).to have_content(@order_1.updated_at)
      expect(page).to have_content(@order_1.status)
      expect(page).to have_content(@order_1.total_items)
      expect(page).to have_content(@order_1.grandtotal)

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_content(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
        expect(page).to have_content(2)
        expect(page).to have_content(4.50)
        expect(page).to have_content(9.00)
      end

      within "#item-#{@dog_bone.id}" do
        expect(page).to have_content(@dog_bone.name)
        expect(page).to have_content(@dog_bone.description)
        expect(page).to have_css("img[src*='#{@dog_bone.image}']")
        expect(page).to have_content(1)
        expect(page).to have_content(7.00)
        expect(page).to have_content(7.00)
      end
    end

    it "has a link to cancel the order" do
      visit '/login'
      fill_in :email, with: @kiera.email
      fill_in :password, with: @kiera.password
      click_button 'Login'

      visit "/profile/orders/#{@order_1.id}"

      expect(page).to have_button("Cancel Order")
    end

    it "can cancel an order" do
      visit '/login'
      fill_in :email, with: @kiera.email
      fill_in :password, with: @kiera.password
      click_button 'Login'

      visit "/profile/orders/#{@order_1.id}"

      click_button "Cancel Order"

      expect(page).to have_content("Cancelled")
      expect(current_path).to eq("/profile/orders/#{@order_1.id}")

      @item_order_1.reload
      @item_order_2.reload

      expect(@item_order_1.status).to eq("unfulfilled")
      expect(@item_order_2.unfulfilled?).to be_truthy
    end

    it "shows a flash message telling me the order is now cancelled" do
      visit '/login'
      fill_in :email, with: @kiera.email
      fill_in :password, with: @kiera.password
      click_button 'Login'

      visit "/profile/orders/#{@order_1.id}"

      click_button "Cancel Order"

      expect(page).to have_content("Your order has been cancelled.")
    end

    it "Any item quantities in the order that were previously fulfilled have their quantities returned to their respective merchant's inventory for that item." do
      visit '/login'
      fill_in :email, with: @kiera.email
      fill_in :password, with: @kiera.password
      click_button 'Login'

      visit "/profile/orders/#{@order_1.id}"

      click_button "Cancel Order"

      expect(@pull_toy.inventory).to eq(32)
      expect(@dog_bone.inventory).to eq(21)
    end
  end
end
