class Discount < ApplicationRecord
  belongs_to :merchant
  validates :amount, :threshold, presence: true

end
