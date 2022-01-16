class InvoiceItemsController < ApplicationController
  def update
    invoice_item = InvoiceItem.find(params[:id])
    invoice_item.update(invoice_item_params)

    merchant = Merchant.find(params[:merchant_id])
    invoice = Invoice.find(invoice_item.invoice.id)
    redirect_to merchant_invoice_path(merchant, invoice)
  end

private

  def invoice_item_params
    params.require(:invoice_item).permit(:status)
  end
end
