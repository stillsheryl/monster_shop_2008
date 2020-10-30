require 'rails_helper'

describe "As a registered User" do
  describe "when I visit my profile page" do
    before(:each) do
      @kiera = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password', role: 0)

      visit '/login'

      fill_in :email, with: @kiera.email
      fill_in :password, with: @kiera.password

      click_button 'Login'
    end
    it "I see a link to edit my data, which takes me to a profile edit form" do
      click_link "Edit Profile"
      # Definitely refactor after user profile is pulled down
      expect(page).to have_css('#edit-profile-form')
    end
    it "the form is prepopulated with users current info except my password" do
      # click_link "Edit Profile"
      visit '/profile/edit'

      expect(find_field(:name).value).to eq(@kiera.name)
      expect(find_field(:address).value).to eq(@kiera.address)
      expect(find_field(:city).value).to eq(@kiera.city)
      expect(find_field(:state).value).to eq(@kiera.state)
      expect(find_field(:zip).value).to eq("#{@kiera.zip}")
      expect(find_field(:email).value).to eq(@kiera.email)
      expect(page).to have_button("Submit")
    end
    # it "text" do
    #
    # end
  end
end
# [ ] done
#
# User Story 20, User Can Edit their Profile Data
#
# As a registered user
# When I visit my profile page
# When I change any or all of that information
# And I submit the form
# Then I am returned to my profile page
# And I see a flash message telling me that my data is updated
# And I see my updated information
#
