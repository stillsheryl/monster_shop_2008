require 'rails_helper'

describe "As a registered user" do
  describe "When I visit my Profile Orders page, '/profile/orders'" do

    before :each do
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

      @kiera = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password')
      @order_1 = @kiera.orders.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, user_id: @kiera.id)
      @order_2 = @kiera.orders.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, user_id: @kiera.id)

      ItemOrder.create!(order_id: @order_1.id, item_id: @pull_toy.id, price: 4.50, quantity: 2)
      ItemOrder.create!(order_id: @order_1.id, item_id: @dog_bone.id, price: 7.00, quantity: 1)
      ItemOrder.create!(order_id: @order_2.id, item_id: @dog_bone.id, price: 7.00, quantity: 5)
    end

    it "I see every order I've made, which includes all of the order's information" do
      visit '/login'

      fill_in :email, with: @kiera.email
      fill_in :password, with: @kiera.password

      click_button 'Login'

      visit "/profile/orders/"

      within "#order-#{@order_1.id}" do
        expect(page).to have_content(@order_1.id)
        expect(page).to have_content(@order_1.created_at)
        expect(page).to have_content(@order_1.updated_at)
        expect(page).to have_content(@order_1.status)
        expect(page).to have_content(3)
        expect(page).to have_content(@order_1.grandtotal)
      end

      within "#order-#{@order_2.id}" do
        expect(page).to have_content(@order_2.id)
        expect(page).to have_content(@order_2.created_at)
        expect(page).to have_content(@order_2.updated_at)
        expect(page).to have_content(@order_2.status)
        expect(page).to have_content(5)
        expect(page).to have_content(@order_2.grandtotal)
      end
    end

    it "the ID of the order is a link to the order show page" do
      visit '/login'

      fill_in :email, with: @kiera.email
      fill_in :password, with: @kiera.password

      click_button 'Login'

      visit "/profile/orders/"

      find("#link-#{@order_1.id}").click
      expect(current_path).to eq("/profile/orders/#{@order_1.id}")

      visit "/profile/orders/"

      find("#link-#{@order_2.id}").click
      expect(current_path).to eq("/profile/orders/#{@order_2.id}")
    end
  end
end
