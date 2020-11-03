require 'rails_helper'

describe "As an admin user" do
  before :each do
    @bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @dog_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    @tire = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @bell = @bike_shop.items.create!(name: "Silver Bell", description: "Let everyone know you're coming!", price: 25, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 10)
    @helmet = @bike_shop.items.create!(name: "Helmet", description: "Protect your head!", price: 150, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 20)
    @pull_toy = @dog_shop.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @dog_shop.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    @spring = @dog_shop.items.create!(name: "Spring Toy", description: "Best thing to chase", price: 7, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 53)

    @user1 = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password', role: 0)
    @user2 = User.create!(name: 'Tim Tyrell', address: '421 Branch St.', city: 'Denver', state: 'CO', zip: 80205, email: 'you_hate@to_see_it.com', password: 'password', role: 0)
    @admin = User.create!(name: 'Bob Ross', address: '745 Rose St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@ross.com', password: 'password', role: 2)

    @order1 = @user1.orders.create!(name: @user1.name, address: @user1.address, city: @user1.city, state: @user1.state, zip: @user1.zip)
    @order1.item_orders.create!([{ item: @tire, quantity: 2, price: @tire.price }, { item: @bell, quantity: 1, price: @bell.price }, { item: @helmet, quantity: 1, price: @helmet.price }])

    @order2 = @user1.orders.create!(name: @user1.name, address: @user1.address, city: @user1.city, state: @user1.state, zip: @user1.zip)
    @order2.item_orders.create!([{ item: @pull_toy, quantity: 2, price: @pull_toy.price }, { item: @dog_bone, quantity: 3, price: @dog_bone.price }, { item: @spring, quantity: 1, price: @spring.price }])

    @order3 = @user2.orders.create!(name: @user2.name, address: @user2.address, city: @user2.city, state: @user2.state, zip: @user2.zip)
    @order3.item_orders.create!(item: @tire, quantity: 2, price: @tire.price)

    visit '/login'

    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password

    click_button 'Login'

    visit '/admin'
  end
  describe "when I visit my admin dashboard ('/admin')" do
    it "I see all orders in the system and each order's information" do
      within '#all-orders' do
        within "#order-#{@order1.id}" do
          expect(page).to have_link(@order1.name)
          expect(page).to have_content(@order1.id)
          expect(page).to have_content(@order1.created_at.to_date)
        end
        within "#order-#{@order2.id}" do
          expect(page).to have_link(@order2.name)
          expect(page).to have_content(@order2.id)
          expect(page).to have_content(@order2.created_at.to_date)
        end
        within "#order-#{@order3.id}" do
          expect(page).to have_link(@order3.name)
          expect(page).to have_content(@order3.id)
          expect(page).to have_content(@order3.created_at.to_date)
        end
      end
    end
    it "each user name under orders is a link to the admin view of that user's profile" do
      within "#order-#{@order1.id}" do
        click_link(@order1.name)
      end

      expect(current_path).to eq("/admin/users/#{@order1.user_id}")

      visit '/admin'

      within "#order-#{@order2.id}" do
        click_link(@order2.name)
      end

      expect(current_path).to eq("/admin/users/#{@order2.user_id}")

      visit '/admin'

      within "#order-#{@order3.id}" do
        click_link(@order3.name)
      end

      expect(current_path).to eq("/admin/users/#{@order3.user_id}")
    end
  end
end

# User Story 32, Admin can see all orders
#
# Orders are sorted by "status" in this order:
#
# - packaged
# - pending
# - shipped
# - cancelled
