# frozen_string_literal: true

FactoryBot.define do
  factory :taxon, class: Spree::Taxon do
    sequence(:name) { |n| "Taxon#{n}" }
    taxonomy
  end
end
