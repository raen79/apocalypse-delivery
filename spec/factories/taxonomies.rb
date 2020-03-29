# frozen_string_literal: true

FactoryBot.define do
  factory :taxonomy, class: Spree::Taxonomy do
    sequence(:name) { |n| "Taxonomy#{n}" }
    position { 1 }
  end
end
