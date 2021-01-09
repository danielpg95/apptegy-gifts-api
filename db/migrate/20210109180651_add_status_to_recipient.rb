class AddStatusToRecipient < ActiveRecord::Migration[6.1]
  def change
    add_column :recipients, :enabled, :boolean, default: true
  end
end
