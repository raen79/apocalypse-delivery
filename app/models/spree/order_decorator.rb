# frozen_string_literal: true

module Spree
  module OrderDecorator
    def self.prepended(base)
      base.belongs_to :nearest_store, class_name: 'Store', optional: true
    end

    Spree::Order.prepend self
  end
end
