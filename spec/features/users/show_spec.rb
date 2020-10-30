require "rails_helper"

describe "As a registered user" do
  describe "When I visit my profile page" do
    it "Then I see all of my profile data on the page except my password" do
      kiera = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password')

      visit '/login'

      fill_in :email, with: kiera.email
      fill_in :password, with: kiera.password

      click_button 'Login'

      visit '/profile'

      expect(page).to have_content(kiera.name)
      expect(page).to have_content(kiera.address)
      expect(page).to have_content(kiera.city)
      expect(page).to have_content(kiera.state)
      expect(page).to have_content(kiera.zip)
      expect(page).to have_content(kiera.email)

    end

    it "And I see a link to edit my profile data" do
      kiera = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password')

      visit '/login'

      fill_in :email, with: kiera.email
      fill_in :password, with: kiera.password

      click_button 'Login'

      visit '/profile'

      expect(page).to have_link("Edit Profile")
    end

    it "shows a link on my profile page called 'My Orders' if I have orders placed in the system." do
      kiera = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password')
      order_1 = kiera.orders.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, user_id: kiera.id)
      order_2 = kiera.orders.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, user_id: kiera.id)

      visit '/login'

      fill_in :email, with: kiera.email
      fill_in :password, with: kiera.password

      click_button 'Login'

      visit '/profile'

      expect(page).to have_link("My Orders")
    end

    it "does not shows a link on my profile page called 'My Orders' if I have no orders placed in the system." do
      kiera = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password')

      visit '/login'
      fill_in :email, with: kiera.email
      fill_in :password, with: kiera.password

      click_button 'Login'

      visit '/profile'

      expect(page).to_not have_link("My Orders")
    end
  end
end
