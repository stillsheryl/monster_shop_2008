require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
    it { should belong_to(:user) }
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @user1 = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password', role: 0)

      @order_1 = @user1.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)

      @item_order_1 = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @item_order_2 = @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    end
    it '#grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end
    it "#total_items" do
      expect(@order_1.total_items).to eq(5)
    end
    it "#all_fulfilled?" do
      expect(@order_1.all_fulfilled?).to be_falsey

      @item_order_1.update(status: "fulfilled")
      @item_order_2.update(status: "fulfilled")

      expect(@order_1.all_fulfilled?).to be_truthy
    end
  end
  describe "class methods" do
    it "::status_sorted" do
      user1 = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password', role: 0)
      order1 = user1.orders.create!(name: user1.name, address: user1.address, city: user1.city, state: user1.state, zip: user1.zip, status: "shipped")
      order2 = user1.orders.create!(name: user1.name, address: user1.address, city: user1.city, state: user1.state, zip: user1.zip, status: "cancelled")
      order3 = user1.orders.create!(name: user1.name, address: user1.address, city: user1.city, state: user1.state, zip: user1.zip, status: "packaged")
      order4 = user1.orders.create!(name: user1.name, address: user1.address, city: user1.city, state: user1.state, zip: user1.zip, status: "pending")
      expected = [order3, order4, order1, order2]

      expect(Order.status_sorted).to eq(expected)
    end
  end
end
