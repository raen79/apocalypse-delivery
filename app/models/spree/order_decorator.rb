# frozen_string_literal: true

module Spree
  module OrderDecorator
    def self.prepended(base)
      base.belongs_to :nearest_store, class_name: '::Store', optional: true

      base.scope :picked, -> { base.where.not(picked_at: nil) }
      base.scope :not_picked, -> { base.where(picked_at: nil) }
    end

    def pick!
      touch(:picked_at)
    end

    Spree::Order.prepend self
  end
end
