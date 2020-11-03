class User < ApplicationRecord
  has_secure_password

  validates_presence_of :name, :address, :city, :state, :zip
  validates :email, uniqueness: true, presence: true
  validates :password, confirmation: true, presence: true

  has_many :orders
  belongs_to :merchant, optional: true

  enum role: %w(user merchant admin)

  def email_exist?(email)
    users = User.where.not(id: id)
    users.distinct.pluck("email").include?(email)
  end
end
