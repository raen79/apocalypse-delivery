class AddLockedToSpreeTaxonomies < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_taxonomies, :locked, :boolean, default: false
  end
end
