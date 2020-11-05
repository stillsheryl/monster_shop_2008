require 'rails_helper'

RSpec.describe 'As a merchant employee', type: :feature do
  describe 'When I visit my items page and I click the edit button or link next to any item' do
    describe "Then I am taken to a form similar to the new item form the form is pre-populated with all of this item's information" do
      describe "I can change any information, but all of the rules for adding a new item still apply: name and description cannot be blank, price cannot be less than $0.00, inventory must be 0 or greater" do
        before :each do
          @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

          @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
          @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
          @leash = @dog_shop.items.create(name: "Leash", description: "Walk that dog!", price: 15, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 41)

          @sally = User.create!(name: 'Sally Peach', address: '432 Grove St.', city: 'Denver', state: 'CO', zip: 80205, email: 'sallypeach.com', password: 'password', role: 1, merchant_id: @dog_shop.id)

          visit '/login'

          fill_in :email, with: @sally.email
          fill_in :password, with: @sally.password

          click_button 'Login'
        end

        it "When I submit the form I am taken back to my items page I see a flash message indicating my item is updated" do
          visit "/merchant/items"

          expect(page).to have_link("Edit #{@pull_toy.name}")
          click_link "Edit #{@pull_toy.name}"
          expect(current_path).to eq("/merchant/items/#{@pull_toy.id}/edit")

          expect(find_field(:name).value).to eq(@pull_toy.name)
          expect(find_field(:description).value).to eq(@pull_toy.description)
          expect(find_field(:image).value).to eq(@pull_toy.image)
          expect(find_field(:price).value).to eq((@pull_toy.price).to_s)
          expect(find_field(:inventory).value).to eq("#{@pull_toy.inventory}")
          expect(page).to have_button("Submit")

          fill_in :name, with: "Bone"
          fill_in :description, with: "Chewy"
          fill_in :image, with: @pull_toy[:image]
          fill_in :price, with: "30"
          fill_in :inventory, with: @pull_toy[:inventory]

          click_button 'Submit'

          expect(current_path).to eq("/merchant/items")
          expect(page).to have_content("Bone Information Updated.")

          expect(page).to have_content("Bone")
          expect(page).to have_content("Chewy")
          have_css("img[image]")
          expect(page).to have_content("30")
          expect(page).to have_content(@pull_toy[:inventory])
        end


        # If I left the image field blank, I see a placeholder image for the thumbnail
        it "Checks edge cases for name cannot be blank" do
          visit "/merchant/items"

          click_link "Edit #{@pull_toy.name}"

          fill_in :name, with: ""

          click_button 'Submit'

          expect(current_path).to eq("/merchant/items/#{@pull_toy.id}/edit")
          expect(page).to have_content("Name can't be blank")
        end

        it "Checks edge cases for name cannot be blank" do
          visit "/merchant/items"

          click_link "Edit #{@pull_toy.name}"

          fill_in :description, with: ""

          click_button 'Submit'

          expect(current_path).to eq("/merchant/items/#{@pull_toy.id}/edit")
          expect(page).to have_content("Description can't be blank")
        end

        it "Checks edge cases for price must be greater than 0" do
          visit "/merchant/items"

          click_link "Edit #{@pull_toy.name}"

          fill_in :price, with: -2

          click_button 'Submit'

          expect(current_path).to eq("/merchant/items/#{@pull_toy.id}/edit")
          expect(page).to have_content("Price must be greater than 0")
        end

        it "Checks edge cases for inventory must be 0 or greater" do
          visit "/merchant/items"

          click_link "Edit #{@pull_toy.name}"

          fill_in :inventory, with: -2

          click_button 'Submit'
          expect(current_path).to eq("/merchant/items/#{@pull_toy.id}/edit")
          expect(page).to have_content("Inventory must be greater than -1")
        end

        it "Checks edge cases for if I left the image field blank, I see a placeholder image for the thumbnail" do
          visit "/merchant/items"

          click_link "Edit #{@pull_toy.name}"

          fill_in :image, with: ""

          click_button 'Submit'

          expect(current_path).to eq("/merchant/items")

          within("#item-#{@pull_toy.id}") do
            expect(page.find("#setimage")['src']).to have_content("https://thumbs.dreamstime.com/z/no-image-available-icon-photo-camera-flat-vector-illustration-132483097.jpg")
          end
        end
      end
    end
  end
end
