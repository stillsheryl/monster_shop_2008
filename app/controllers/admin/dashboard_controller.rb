class Admin::DashboardController < Admin::BaseController
  def index
    @orders = Order.all
  end

  def users

  end
end
