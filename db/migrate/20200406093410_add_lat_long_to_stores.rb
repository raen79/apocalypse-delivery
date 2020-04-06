class AddLatLongToStores < ActiveRecord::Migration[6.0]
  def change
    add_column :stores, :latitude, :decimal, precision: 8, scale: 6
    add_column :stores, :longitude, :decimal, precision: 8, scale: 6

    add_index :stores, %i[latitude longitude]
  end
end
