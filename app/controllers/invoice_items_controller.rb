class InvoiceItemsController < ApplicationController
  def update
    invoice_item = InvoiceItem.find(params[:id])
    merchant = Merchant.find(params[:merchant_id])
    invoice = Invoice.find(invoice_item.invoice.id)
    invoice_item.update(invoice_item_params)
    if invoice_item.save(invoice_item_params)
      redirect_to merchant_invoice_path(merchant, invoice)
      flash[:alert] = "Successfully Updated Order"
    else
      redirect_to merchant_invoice_path(merchant, invoice)
      flash[:alert] = "Error: #{error_message(invoice_item.errors)}"
    end
  end

private

  def invoice_item_params
    params.require(:invoice_item).permit(:status)
  end
end
