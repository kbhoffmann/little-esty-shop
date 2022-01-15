class MerchantDiscountsController < ApplicationController
  def index
    @facade = MerchantFacade.new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @discount = Discount.find(params[:discount_id])
  end
end
