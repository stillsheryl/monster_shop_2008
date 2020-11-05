class Merchant::ItemsController < ApplicationController
  before_action :require_merchant

  def index
    @items = current_user.merchant.items
  end

  def new
  end

  def create
    merchant = current_user.merchant
    item = merchant.items.new(item_params)
    if item.save
      flash[:mesage] = "Your new item has been saved and is now active and available for sale."
      redirect_to '/merchant/items'
    else
      flash[:errors] = item.errors.full_messages.uniq.to_sentence
      redirect_to '/merchant/items/new'
    end
  end

  def update
    merchant = current_user.merchant
    item = merchant.items.find(params[:item_id])
    if item.active?
      item.update(active?: false)
      flash[:mesage] = "Your item is now inactive and no longer for sale."
    else
      item.update(active?: true)
      flash[:mesage] = "Your item is now active and is now available for sale."
    end
    redirect_to '/merchant/items'
  end

  def destroy
    merchant = current_user.merchant
    item = merchant.items.find(params[:item_id])
    item.destroy
    flash[:mesage] = "Your #{item.name} item has been deleted."
    redirect_to '/merchant/items'
  end

  private
    def require_merchant
      render file: "/public/404" unless current_merchant?
    end

    def item_params
      if params[:image] != ""
        params.permit(:name,:description,:image,:price,:inventory)
      else
        params.permit(:name,:description,:price,:inventory)
      end
    end
end
