require 'rails_helper'

describe "Admin User Index Spec:" do
  before :each do
    @user = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password', role: 0)
    merchant = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @merchant_user = User.create!(name: 'Sally Peach', address: '432 Grove St.', city: 'Denver', state: 'CO', zip: 80205, email: 'sally@peach.com', password: 'password', role: 1, merchant_id: merchant.id)
    @admin = User.create!(name: 'Bob Ross', address: '745 Rose St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@ross.com', password: 'password', role: 2)
  end

  describe "As an admin user" do
    before :each do
      visit '/login'

      fill_in :email, with: @admin.email
      fill_in :password, with: @admin.password

      click_button 'Login'

      within "nav" do
        click_link 'Users'
      end
    end

    describe "When I click on the 'Users' link" do
      it "my current URL route is '/admin/users'" do
        expect(current_path).to eq(admin_users_path)
      end

      it "I see all users in the system" do
        within '#users' do
          within "user-#{@admin.id}" do
              expect(page).to have_content("Name: #{@admin.name}")
              expect(page).to have_content("Permissions: #{@admin.role.upcase}")
              expect(page).to have_content("Registration Date: #{@admin.created_at.to_date}")

              click_link(@admin.name)
          end
        end

        expect(current_path).to eq(admin_users_path(@admin.id))

        visit admin_users_path

        within '#users' do
          within "user-#{@admin.id}" do
              expect(page).to have_content("Name: #{@admin.name}")
              expect(page).to have_content("Permissions: #{@admin.role.upcase}")
              expect(page).to have_content("Registration Date: #{@admin.created_at.to_date}")

              click_link(@admin.name)
          end
        end

        expect(current_path).to eq(admin_users_path(@admin.id))

        visit admin_users_path

        within '#users' do
          within "user-#{@admin.id}" do
              expect(page).to have_content("Name: #{@admin.name}")
              expect(page).to have_content("Permissions: #{@admin.role.upcase}")
              expect(page).to have_content("Registration Date: #{@admin.created_at.to_date}")

              click_link(@admin.name)
          end
        end

        expect(current_path).to eq(admin_users_path(@admin.id))

        visit admin_users_path  
      end
    end
  end
  describe "As a regular User" do
    before :each do
      visit '/login'

      fill_in :email, with: @user.email
      fill_in :password, with: @user.password

      click_button 'Login'
    end

    it "I don't see a 'Users' link in the nav bar" do
      within "nav" do
        expect(page).to_not have_link('Users')
      end
    end

    it "I cannot access '/admin/users'" do
      visit admin_users_path

      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end

  describe "As a merchant User" do
    before :each do
      visit '/login'

      fill_in :email, with: @merchant_user.email
      fill_in :password, with: @merchant_user.password

      click_button 'Login'
    end

    it "I don't see a 'Users' link in the nav bar" do
      within "nav" do
        expect(page).to_not have_link('Users')
      end
    end

    it "I cannot access '/admin/users'" do
      visit admin_users_path

      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
end
describe "As a visitor" do
  it "I don't see a 'Users' link in the nav bar" do
    visit '/'
    within "nav" do
      expect(page).to_not have_link('Users')
    end
  end

  it "I cannot access '/admin/users'" do
    visit admin_users_path

    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end
