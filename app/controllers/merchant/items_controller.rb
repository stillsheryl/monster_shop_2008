class Merchant::ItemsController < ApplicationController
  before_action :require_merchant

  def index
    @items = current_user.merchant.items
  end

  def deactivate
    redirect_to 'merchant/items'

  end

  private
    def require_merchant
      render file: "/public/404" unless current_merchant?
    end
end
