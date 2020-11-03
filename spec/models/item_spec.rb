require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @tire = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @bell = @bike_shop.items.create!(name: "Silver Bell", description: "Let everyone know you're coming!", price: 25, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 10)
      @kickstand = @bike_shop.items.create!(name: "Kickstand", description: "Don't fall!", price: 75, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 4)
      @helmet = @bike_shop.items.create!(name: "Helmet", description: "Protect your head!", price: 150, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 20)
      @streamers = @bike_shop.items.create!(name: "streamers", description: "Everyone will see you coming!", price: 50, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 15)
      @seat = @bike_shop.items.create!(name: "Seat", description: "Protect your bum!", price: 90, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 7)

      @sheryl = User.create!(name: 'Sheryl S', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'sheryl@marley.com', password: 'password', role: 0)
      @curtis = User.create!(name: 'Curtis B', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'curtis@marley.com', password: 'password', role: 0)

      @order_1 = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 23455, user_id: @sheryl.id)
      @order_2 = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 80203, user_id: @curtis.id)

      ItemOrder.create!(order_id: @order_1.id, price: 1.0, item_id: @tire.id, quantity: 5)
      ItemOrder.create!(order_id: @order_1.id, price: 1.0, item_id: @bell.id, quantity: 1)
      ItemOrder.create!(order_id: @order_1.id, price: 1.0, item_id: @kickstand.id, quantity: 4)
      ItemOrder.create!(order_id: @order_1.id, price: 1.0, item_id: @helmet.id, quantity: 3)
      ItemOrder.create!(order_id: @order_1.id, price: 1.0, item_id: @seat.id, quantity: 2)

      ItemOrder.create!(order_id: @order_2.id, price: 1.0, item_id: @tire.id, quantity: 1)
      ItemOrder.create!(order_id: @order_2.id, price: 1.0, item_id: @kickstand.id, quantity: 4)
      ItemOrder.create!(order_id: @order_2.id, price: 1.0, item_id: @seat.id, quantity: 4)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "total_sold" do
      expect(@tire.total_sold).to eq(6)
      expect(@bell.total_sold).to eq(1)
      expect(@kickstand.total_sold).to eq(8)
      expect(@helmet.total_sold).to eq(3)
      expect(@seat.total_sold).to eq(6)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      order = Order.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end
  end
  describe "class methods" do
    before(:each) do
      @bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @tire = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @bell = @bike_shop.items.create!(name: "Silver Bell", description: "Let everyone know you're coming!", price: 25, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 10)
      @kickstand = @bike_shop.items.create!(name: "Kickstand", description: "Don't fall!", price: 75, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 4)
      @helmet = @bike_shop.items.create!(name: "Helmet", description: "Protect your head!", price: 150, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 20)
      @streamers = @bike_shop.items.create!(name: "Streamers", description: "Everyone will see you coming!", price: 50, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 15)
      @seat = @bike_shop.items.create!(name: "Seat", description: "Protect your bum!", price: 90, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 7)

      @kiera = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password', role: 0)

      @order_1 = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 23455, user_id: @kiera.id)
      @order_2 = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 80203, user_id: @kiera.id)

      ItemOrder.create!(order_id: @order_1.id, price: 1.0, item_id: @streamers.id, quantity: 5)
      ItemOrder.create!(order_id: @order_1.id, price: 1.0, item_id: @seat.id, quantity: 1)
      ItemOrder.create!(order_id: @order_1.id, price: 1.0, item_id: @tire.id, quantity: 4)
      ItemOrder.create!(order_id: @order_1.id, price: 1.0, item_id: @bell.id, quantity: 3)
      ItemOrder.create!(order_id: @order_1.id, price: 1.0, item_id: @helmet.id, quantity: 2)

      ItemOrder.create!(order_id: @order_2.id, price: 1.0, item_id: @helmet.id, quantity: 1)
      ItemOrder.create!(order_id: @order_2.id, price: 1.0, item_id: @bell.id, quantity: 4)
    end

    it "top_five" do
      expected = {@bell.name => @bell.total_sold,
                  @streamers.name => @streamers.total_sold,
                  @tire.name => @tire.total_sold,
                  @helmet.name => @helmet.total_sold,
                  @seat.name => @seat.total_sold}
      expect(Item.top_five).to eq(expected)
    end

    it "bottom_five" do
      expected = {@seat.name => @seat.total_sold,
                  @helmet.name => @helmet.total_sold,
                  @tire.name => @tire.total_sold,
                  @streamers.name => @streamers.total_sold,
                  @bell.name => @bell.total_sold}
      expect(Item.bottom_five).to eq(expected)
    end
  end
end
