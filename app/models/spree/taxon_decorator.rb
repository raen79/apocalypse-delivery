# frozen_string_literal: true

module Spree
  module TaxonDecorator
    def self.prepended(base)
      base.delegate :locked?, to: :taxonomy

      base.has_one :store, class_name: '::Store', foreign_key: 'spree_taxon_id'
    end

    Spree::Taxon.prepend self
  end
end
