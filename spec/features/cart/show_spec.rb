require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    describe 'and visit my cart path' do
      before(:each) do
        @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

        @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
        @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
        visit "/items/#{@paper.id}"
        click_on "Add To Cart"
        visit "/items/#{@tire.id}"
        click_on "Add To Cart"
        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"
        @items_in_cart = [@paper,@tire,@pencil]
      end

      it 'I can empty my cart by clicking a link' do
        visit '/cart'
        expect(page).to have_link("Empty Cart")
        click_on "Empty Cart"
        expect(current_path).to eq("/cart")
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it 'I see all items Ive added to my cart' do
        visit '/cart'

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_link(item.name)
            expect(page).to have_css("img[src*='#{item.image}']")
            expect(page).to have_link("#{item.merchant.name}")
            expect(page).to have_content("$#{item.price}")
            expect(page).to have_content("1")
            expect(page).to have_content("$#{item.price}")
          end
        end
        expect(page).to have_content("Total: $122")

        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"

        visit '/cart'

        within "#cart-item-#{@pencil.id}" do
          expect(page).to have_content("2")
          expect(page).to have_content("$4")
        end

        expect(page).to have_content("Total: $124")
      end

      it "has a button next to each item to increase the count of items" do
        visit '/cart'

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_button("+")
          end
        end

        within "#cart-item-#{@paper.id}" do
          click_button "+"
        end

        expect(page).to have_content("Cart: 4")
      end

      it "cannot add more items than in inventory" do
        visit '/cart'

        within "#cart-item-#{@paper.id}" do
          click_button "+"
          click_button "+"
          click_button "+"
        end

        expect(page).to have_content("There are no more items left in inventory")
      end

      it "has a button next to each item to decrease the count of items" do
        visit '/cart'

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_button("-")
          end
        end

        within "#cart-item-#{@paper.id}" do
          click_button "-"
        end

        expect(page).to have_content("Cart: 2")
      end

      it "will remove item if quantity gets to 0" do
        visit '/cart'

        within "#cart-item-#{@paper.id}" do
          click_button "-"
        end

        expect(page).to_not have_content(@paper.name)
      end

      it "I must register or login before checking out" do
        visit '/cart'

        within("#must-login") do
          expect(page).to have_content("Please Register or Log In to checkout.")
          expect(page).to have_link("Register")
          expect(page).to have_link("Log In")
        end

        click_on "Register"
        expect(current_path).to eq('/register')

        visit '/cart'

        click_on "Log In"
        expect(current_path).to eq('/login')
      end
    end
  end

  describe "When I haven't added anything to my cart" do
    describe "and visit my cart show page" do
      it "I see a message saying my cart is empty" do
        visit '/cart'
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it "I do NOT see the link to empty my cart" do
        visit '/cart'
        expect(page).to_not have_link("Empty Cart")
      end

    end
  end
end
