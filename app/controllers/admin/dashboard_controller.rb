class Admin::DashboardController < Admin::BaseController
  def index
    @orders = Order.status_sorted
  end

  def users
    
  end
end
