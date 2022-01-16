class InvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = Invoice.find(params[:id])
    @invoice_items = @invoice.invoice_items
  end

  def update
    invoice = Invoice.find(params[:id])
    merchant = Merchant.find(params[:merchant_id])
    invoice.update(invoice_params)
    if invoice.save(invoice_params)
      redirect_to merchant_invoice_path(merchant, invoice)
      flash[:alert] = "Successfully Updated Invoice"
    else
      redirect_to merchant_invoice_path(merchant, invoice)
      flash[:alert] = "Error: #{error_message(invoice.errors)}"
    end
  end

private
  def invoice_params
    params.require(:invoice).permit(:status)
  end

end
