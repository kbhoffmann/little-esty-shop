class Merchant < ApplicationRecord
  has_many :items
  has_many :discounts
  validates :name, presence: true

  enum status: [:disabled, :enabled]
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices
  validates :name, presence: true


  def self.top_merchants
    joins(invoices: [:invoice_items, :transactions])
      .where(transactions: { result: 1 })
      .select("merchants.*, SUM(invoice_items.unit_price * invoice_items.quantity) AS merchant_revenue")
      .group(:id)
      .limit(5)
      .order(merchant_revenue: :desc)
  end

  def top_customers
    customers.joins(invoices: :transactions)
       .select("customers.*, count(transactions.id) as transaction_id_count")
       .limit(5)
       .group(:id)
       .order(transaction_id_count: :desc)
       .where(transactions: { result: 1 } )

  end

  def ready_items
    items.joins(invoice_items: :invoice)
        .where(invoice_items: {status: "packaged"})
        .select("items.*, invoices.created_at")
        .order("invoices.created_at asc")
  end

  def top_items
    items.joins(invoices: :transactions)
          .where(invoices: {status: 1}, transactions: {result: 1})
          .select("items.id, items.name, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
          .group(:id)
          .order("revenue desc")
          .limit(5)
  end

  def filter_item_status(status_enum)
    items.where(status: status_enum)
  end

  def self.filter_merchant_status(status_enum)
    where(status: status_enum)
  end

  def best_day
    invoices.where(status: 2)
            .joins(:invoice_items)
            .select('invoices.created_at, sum(invoice_items.unit_price * invoice_items.quantity) as revenue')
            .group('invoices.created_at')
            .order('revenue desc', 'invoices.created_at desc')
            .first&.created_at
  end
end
