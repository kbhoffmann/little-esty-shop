class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  validates :item, :invoice, :status, presence: true
  validates :quantity, :unit_price, numericality: { only_integer: true }

    enum status: {
    pending: 0,
    packaged: 1,
    shipped: 2
  }

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end
end
