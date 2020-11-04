class Admin::MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end

  def disable
    @merchant = Merchant.find(params[:merchant_id])
    @merchant.update(active?: false)
    @merchant.items.update(active?: false)
    redirect_to "/admin/merchants"
    flash[:notice] = "#{@merchant.name} is disabled"
  end
end
