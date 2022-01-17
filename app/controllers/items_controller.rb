class ItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @enabled_items = @merchant.items.where(status: 1)
    @disabled_items = @merchant.items.where(status: 0)
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end

  def update
    item = Item.find(params[:id])
    merchant = Merchant.find(params[:merchant_id])
    if params[:status] == "enabled"
      item.update(status: 1)
      redirect_to merchant_items_path(merchant)
    elsif params[:status] == "disabled"
      item.update(status: 0)
      redirect_to merchant_items_path(merchant)
    elsif item.update(item_params)
      redirect_to merchant_item_path(merchant, item)
      flash[:alert] = "Successfully Updated Item"
    else
      redirect_to "/merchant/#{merchant.id}/items/#{item.id}/edit"
      flash[:alert] = "Error: #{error_message(item.errors)}"
    end
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    item = @merchant.items.create(item_params)
    if item.save
      redirect_to merchant_items_path(@merchant)
    else
      redirect_to "/merchants/#{@merchant.id}/items/new"
      flash[:alert] = "Error: #{error_message(item.errors)}"
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :status)
  end
end
