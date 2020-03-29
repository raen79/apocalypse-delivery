# frozen_string_literal: true

FactoryBot.define do
  factory :store do
    sequence(:name) { |n| "Albatross#{n}" }

    email { 'albatross@albatross.com' }
    postcode { '10999' }
    street { 'Reichenberger Str.' }
    street_number { '116' }
    city { 'Berlin' }
    country { 'Germany' }
    phone_number { '10999' }

    root_taxon { create(:store_root_taxon) }
  end

  factory :store_root_taxon, class: Spree::Taxon do
    name { Store::TAXONOMY_NAME }
    taxonomy { create(:store_taxonomy) }
  end

  factory :store_taxonomy, class: Spree::Taxonomy do
    name { Store::TAXONOMY_NAME }
    position { 1 }
  end
end
