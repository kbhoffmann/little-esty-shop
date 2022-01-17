class ChangeColumnType < ActiveRecord::Migration[5.2]
  def change
    change_column(:discounts, :amount, :integer)
  end
end
