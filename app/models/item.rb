class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  validates :name, :description, :merchant, presence: true
  validates :unit_price, numericality: { only_integer: true }

  enum status: [:disabled, :enabled]

  def best_day
    invoices.joins(:invoice_items)
            .where('invoices.status = 2')
            .select('invoices.*, sum(invoice_items.unit_price * invoice_items.quantity) as revenue')
            .group(:id)
            .order('revenue desc', 'created_at desc')
            .first&.created_at&.to_date
  end
end
