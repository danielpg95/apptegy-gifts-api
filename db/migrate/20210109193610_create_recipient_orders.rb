class CreateRecipientOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :recipient_orders do |t|
      t.references :recipient, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
