class CreateStores < ActiveRecord::Migration[6.0]
  def change
    create_table :stores do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :postcode, null: false
      t.string :street, null: false
      t.string :street_number, null: false
      t.string :city, null: false
      t.string :country, null: false
      t.string :phone_number, null: false
      t.boolean :is_hub, null: false, default: true
      t.belongs_to :spree_taxon, null: false, foreign_key: true

      t.timestamps
    end
  end
end
