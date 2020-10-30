class User < ApplicationRecord
  has_secure_password

  validates_presence_of :name, :address, :city, :state, :zip
  validates :email, uniqueness: true, presence: true
  validates :password, confirmation: true, presence: true

  has_many :orders

  enum role: %w(user merchant admin)
end
