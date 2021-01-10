class AddShippedAtToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :shipped_at, :datetime
  end
end
