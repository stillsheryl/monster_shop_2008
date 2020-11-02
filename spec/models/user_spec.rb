require 'rails_helper'

RSpec.describe User do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }

    it { should validate_uniqueness_of :email }

    it { should validate_confirmation_of :password }

    it { should have_many :orders }
  end

  describe "roles" do
    it "can be created as a default user" do
      user = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password')

      expect(user.role).to eq("user")
      expect(user.user?).to be_truthy
    end

    it "can be created as a merchant" do
      merchant = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password', role: 1)

      expect(merchant.role).to eq("merchant")
      expect(merchant.merchant?).to be_truthy
    end

    it "can be created as a admin" do
      admin = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password', role: 2)

      expect(admin.role).to eq("admin")
      expect(admin.admin?).to be_truthy
    end
  end

  describe 'Instance Methods' do
    it "#email_exist?" do
        user = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password')
        User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'kiera@marley.com', password: 'password')
        User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'qjose@marley.com', password: 'password')

        expect(user.email_exist?('bob@marley.com')).to eq(false)
        expect(user.email_exist?('kiera@marley.com')).to eq(true)
    end
  end
end
