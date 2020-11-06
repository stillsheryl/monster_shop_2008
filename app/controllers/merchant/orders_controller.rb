class Merchant::OrdersController < ApplicationController
  before_action :require_merchant

  def show
    @item_orders = current_user.merchant.item_orders.where("order_id = #{params[:id]}")
    @order = Order.find(params[:id])
  end

  def update
    order = Order.find(params[:id])
    item_order = ItemOrder.find(params[:item_order_id])
    new_inventory = item_order.subtract
    item_order.update(status: "fulfilled")
    item_order.item.update(inventory: new_inventory)
    if order.all_fulfilled?
      order.update(status: "Packaged")
    end
    flash[:success] = "Item has been fulfilled"
    redirect_to "/merchant/orders/#{order.id}"
  end


  private
    def require_merchant
      render file: "/public/404" unless current_merchant?
    end

end
