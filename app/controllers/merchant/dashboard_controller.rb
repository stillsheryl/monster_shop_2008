class Merchant::DashboardController < ApplicationController
  before_action :require_merchant

  def index
    @merchant = current_user.merchant
  end

  def update
    merchant = current_user.merchant
    item_order = merchant.item_orders.find(params[:item_order_id])
    order = item_order.order
    item_order.update(status: "fulfilled")
    if order.all_fulfilled?
      order.update(status: "Packaged")
    end
  end

  def items

  end
  
  private
    def require_merchant
      render file: "/public/404" unless current_merchant?
    end
end
