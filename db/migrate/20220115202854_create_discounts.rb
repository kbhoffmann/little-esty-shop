class CreateDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.float :amount
      t.integer :threshold
      t.index :merchant, foreign_key: true

      t.timestamps
    end
  end
end
