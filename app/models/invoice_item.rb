class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_one :merchant, through: :item
  has_many :discounts, through: :merchant

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

  def applicable_discount
    item.merchant.discounts.where('threshold <= ?', quantity).order(amount: :desc).first
  end

  def order_total
    (unit_price.to_f / 100) * quantity
  end

  def discounted_total
    if applicable_discount.nil?
      order_total
    else
      discount_amount = (applicable_discount.amount.to_f / 100) * order_total
      order_total - discount_amount
    end
  end
end
