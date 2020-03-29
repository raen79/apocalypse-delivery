# frozen_string_literal: true

module Spree
  module TaxonDecorator
    delegate :locked?, to: :taxonomy
  end
end

::Spree::Taxon.prepend Spree::TaxonDecorator
