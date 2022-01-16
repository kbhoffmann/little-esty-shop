class MerchantDiscountsController < ApplicationController
  def index
    @facade = MerchantFacade.new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @discount = Discount.find(params[:discount_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    discount = Discount.new(discount_params)
    if discount.save
      redirect_to "/merchants/#{@merchant.id}/discounts"
    else
      redirect_to "/merchants/#{@merchant.id}/discounts/new"
      flash[:alert] = "Error: #{error_message(discount.errors)}"
    end 
  end

private

  def discount_params
    params.permit(:amount, :threshold, :merchant_id)
  end

end
