require 'rails_helper'

describe "As a registered User" do
  describe "when I visit my profile page" do
    before(:each) do
      @kiera = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password', role: 0)
      @jose = { name: "Jose Lopez", address: "125 Candy Cane Ln.", city: "Miami", state: "FL", zip: 54321, email: "bob@marley.com" }

      visit '/login'

      fill_in :email, with: @kiera.email
      fill_in :password, with: @kiera.password

      click_button 'Login'
    end
    it "I see a link to edit my data, which takes me to a profile edit form, which is prepopulated with my current info, except my password" do
      click_link "Edit Profile"

      expect(current_path).to eq('/profile/edit')

      within '#edit-profile-form' do
        expect(find_field(:name).value).to eq(@kiera.name)
        expect(find_field(:address).value).to eq(@kiera.address)
        expect(find_field(:city).value).to eq(@kiera.city)
        expect(find_field(:state).value).to eq(@kiera.state)
        expect(find_field(:zip).value).to eq("#{@kiera.zip}")
        expect(find_field(:email).value).to eq(@kiera.email)
        expect(find_field(:password).value).to eq(@kiera.password)
        expect(page).to have_button("Submit")
      end
    end
    describe "When I change any or all of that information and I submit the form" do
      it "Then I am returned to my profile page, and I see a flash message telling me that my data is updated, and I see my updated information" do
        # click_link "Edit Profile"
        visit '/profile/edit'

        fill_in :name, with: @jose[:name]
        fill_in :address, with: @jose[:address]
        fill_in :city, with: @jose[:city]
        fill_in :state, with: @jose[:state]
        fill_in :zip, with: @jose[:zip]
        fill_in :email, with: @jose[:email]
        fill_in :password, with: @kiera.password

        click_button 'Submit'

        expect(current_path).to eq('/profile')
        expect(page).to have_content('Profile information updated.')

        expect(page).to have_content(@jose[:name])
        expect(page).to have_content(@jose[:address])
        expect(page).to have_content(@jose[:city])
        expect(page).to have_content(@jose[:state])
        expect(page).to have_content(@jose[:zip])
        expect(page).to have_content(@jose[:email])

        click_link "Edit Profile"
        visit '/profile/edit'

        fill_in :name, with: ""
        fill_in :address, with: "125 Candy Cane Ln."
        fill_in :city, with: "Miami"
        fill_in :state, with: "FL"
        fill_in :zip, with: 54321
        fill_in :email, with: "bob@marley.com"
        fill_in :password, with: @kiera.password

        click_button 'Submit'

        expect(current_path).to eq('/profile/edit')
        expect(page).to have_content('No fields can be blank.')

        # click_link "Edit Profile"
        visit '/profile/edit'

        fill_in :name, with: "Jose Lopez"
        fill_in :address, with: "125 Candy Cane Ln."
        fill_in :city, with: "Tampa"
        fill_in :state, with: "FL"
        fill_in :zip, with: 54321
        fill_in :email, with: "bob@marley.com"
        fill_in :password, with: 'fake_password'

        click_button 'Submit'

        expect(current_path).to eq('/profile/edit')
        expect(page).to have_content('Incorrect password.')
      end
    end
  end
end
