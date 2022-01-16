class Transaction < ApplicationRecord
  belongs_to :invoice
  validates :invoice, :credit_card_number, :result, presence: true

    enum result: {
    pending: 0,
    success: 1,
    failed: 2
  }
end
