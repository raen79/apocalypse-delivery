class AddLockedToSpreeTaxonomies < ActiveRecord::Migration[6.0]
  def up
    add_column :spree_taxonomies, :locked, :boolean, default: false
    Rake::Task['lock_store_taxonomy'].invoke
  end

  def down
    remove_column :spree_taxonomies, :locked
  end
end
