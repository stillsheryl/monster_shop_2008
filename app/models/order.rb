class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user

  enum status: %w(Packaged Pending Shipped Cancelled)

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_items
    item_orders.sum('quantity')
  end

  def all_fulfilled?
    item_orders.all? { |item_order| item_order.status == "fulfilled" }
  end

  # def self.status_sorted
  #   require 'pry' ; binding.pry
  # end
end
