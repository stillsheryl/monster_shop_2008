class Merchant::ItemsController < ApplicationController
  before_action :require_merchant

  def index
    @items = current_user.merchant.items
  end

  def deactivate
    merchant = current_user.merchant
    item = merchant.items.find(params[:item_id])
    item.update(active?: false)
    flash[:mesage] = "Your item is now inactive and no longer for sale."
    redirect_to '/merchant/items'
  end

  private
    def require_merchant
      render file: "/public/404" unless current_merchant?
    end
end
