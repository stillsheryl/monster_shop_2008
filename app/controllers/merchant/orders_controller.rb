class Merchant::OrdersController < ApplicationController
  before_action :require_merchant

  def show
    merchant = current_user.merchant
    @item_orders = merchant.item_orders.where("order_id = #{params[:id]}")
  end

  private
    def require_merchant
      render file: "/public/404" unless current_merchant?
    end

end
