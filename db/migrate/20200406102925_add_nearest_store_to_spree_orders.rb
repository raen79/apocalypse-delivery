class AddNearestStoreToSpreeOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_orders, :nearest_store_id, :bigint
    add_foreign_key :spree_orders, :stores, name: :nearest_store, column: :nearest_store_id
    
    add_index :spree_orders, :nearest_store_id
  end
end
