require 'rails_helper'

describe "Admin User Index Page:" do
  before :each do
    @user = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password', role: 0)
    merchant = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @merchant_user = User.create!(name: 'Sally Peach', address: '432 Grove St.', city: 'Denver', state: 'CO', zip: 80205, email: 'sally@peach.com', password: 'password', role: 1, merchant_id: merchant.id)
    @admin = User.create!(name: 'Bob Ross', address: '745 Rose St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@ross.com', password: 'password', role: 2)
  end

  describe "As an admin user," do
    before :each do
      visit '/login'

      fill_in :email, with: @admin.email
      fill_in :password, with: @admin.password

      click_button 'Login'
    end
    describe "when I visit a user's profile page ('admin/users/:user_id')" do
      it "I see the same info the user would see themselves, excluding the link to edit their profile" do

        visit "/admin/users/#{@user.id}"

        expect(page).to have_content(@user.name)
        expect(page).to have_content(@user.address)
        expect(page).to have_content(@user.city)
        expect(page).to have_content(@user.state)
        expect(page).to have_content(@user.zip)
        expect(page).to have_content(@user.email)
        expect(page).to_not have_link("Edit Profile")
        expect(page).to_not have_link("Edit Password")
      end
    end
  end
end
