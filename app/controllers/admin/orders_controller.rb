class Admin::OrdersController < Admin::BaseController
  def update
    order = Order.find(params[:order_id])
    order.update(status: "Shipped")
    flash[:success] = "Order #{order.id} has been shipped successfully."
    redirect_to '/admin'
  end
end
