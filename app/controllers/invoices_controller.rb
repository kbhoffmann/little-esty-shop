class InvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @invoice = Invoice.find(params[:invoice_id])
  end

  def update
    invoice = Invoice.find(params[:invoice_id])
    invoice.update(invoice_params)
    merchant = Merchant.find(params[:merchant_id])

    redirect_to merchant_invoice_path(merchant, invoice)
  end

private
  def invoice_params
    params.require(:invoice).permit(:status)
  end 

end
