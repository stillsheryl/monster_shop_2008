class Merchant::ItemsController < ApplicationController
  before_action :require_merchant

  def index
    @items = current_user.merchant.items
  end

  def new
    merchant = current_user.merchant
    @item = merchant.items.new(item_params)
  end

  def create
    merchant = current_user.merchant
    @item = merchant.items.new(item_params)
    if @item.save
      flash[:mesage] = "Your new item has been saved and is now active and available for sale."
      redirect_to '/merchant/items'
    else
      flash.now[:errors] = @item.errors.full_messages.uniq.to_sentence
      render :new
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

  def edit
    @item = Item.find(params[:id])
  end

  def edit_update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      flash[:success] = "#{@item.name} Information Updated."
      redirect_to "/merchant/items"
    else
      flash.now[:error] = @item.errors.full_messages.to_sentence
      render :edit
    end
  end

  private
    def require_merchant
      render file: "/public/404" unless current_merchant?
    end

    def item_params
      params.permit(:name,:description,:image,:price,:inventory)
    end
end
