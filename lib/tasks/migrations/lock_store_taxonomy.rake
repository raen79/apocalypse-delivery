# frozen_string_literal: true

desc 'This will lock the store taxonomy'
task :lock_store_taxonomy do
  Spree::Taxonomy.find_by(name: Store::TAXONOMY_NAME)&.update(locked: true)
end
