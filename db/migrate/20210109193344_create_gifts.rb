class CreateGifts < ActiveRecord::Migration[6.1]
  def change
    create_table :gifts do |t|
      t.integer :gift_type

      t.timestamps
    end
  end
end
