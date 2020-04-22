class AddPickedAtToSpreeOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_orders, :picked_at, :datetime, default: nil
    add_index :spree_orders, :picked_at
  end
end
