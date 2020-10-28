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
  end

  describe "roles" do
    it "can be created as a default user" do
      User.create!(email: 'kiera@gmail.com', password: 'password', role: 0)

      expect(user.role).to eq("user")
      expect(user.user?).to be_truthy
    end

    it "can be created as a default user" do
      User.create!(email: 'kiera@gmail.com', password: 'password', role: 1)

      expect(user.role).to eq("admin")
      expect(user.admin?).to be_truthy
    end

    it "can be created as a default user" do
      User.create!(email: 'kiera@gmail.com', password: 'password', role: 2)

      expect(user.role).to eq("merchant")
      expect(user.merchant?).to be_truthy
    end
  end
end
