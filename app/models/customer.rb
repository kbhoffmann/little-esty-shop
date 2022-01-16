class Customer < ApplicationRecord
  has_many :invoices
  has_many :transactions, through: :invoices
  validates :first_name, :last_name, presence: true

  def transaction_count
    transactions.where('result = 1').count
  end

  def self.top_5
    joins(:transactions)
      .where(transactions: { result: 1 })
      .group(:id)
      .select("customers.*, count(transactions.id) as transaction_count")
      .order(transaction_count: :desc)
      .limit(5)
  end
end
