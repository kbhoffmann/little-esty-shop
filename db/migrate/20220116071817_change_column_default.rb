class ChangeColumnDefault < ActiveRecord::Migration[5.2]
  def change
    change_column :invoices, :status, :integer, default: 0
    change_column :invoice_items, :status, :integer, default: 0
    change_column :merchants, :status, :integer, default: 0
    change_column :items, :status, :integer, default: 0
    change_column :transactions, :result, :integer, default: 0
  end
end
