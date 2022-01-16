class DiscountsController < ApplicationController
  def index
    @facade = MerchantFacade.new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    discount = @merchant.discounts.create(discount_params)
    if discount.save
      redirect_to merchant_discounts_path(@merchant)
    else
      redirect_to "/merchants/#{@merchant.id}/discounts/new"
      flash[:alert] = "Error: #{error_message(discount.errors)}"
    end
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
    @discount.update(discount_params)
    if @discount.save
      redirect_to merchant_discount_path(@merchant, @discount)
    else
      redirect_to merchant_discount_edit_path(@merchant, @discount)
      flash[:alert] = "Error: #{error_message(discount.errors)}"
    end
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    discount = Discount.find(params[:id])
    discount.destroy
    redirect_to merchant_discounts_path(@merchant)
  end

private

  def discount_params
    params.require(:discount).permit(:amount, :threshold, :merchant_id)
  end

end
