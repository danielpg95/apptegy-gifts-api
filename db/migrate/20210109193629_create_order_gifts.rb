class CreateOrderGifts < ActiveRecord::Migration[6.1]
  def change
    create_table :order_gifts do |t|
      t.references :order, null: false, foreign_key: true
      t.references :gift, null: false, foreign_key: true

      t.timestamps
    end
  end
end
