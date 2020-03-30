# frozen_string_literal: true

require 'spree/core'
require 'solidus_stores'

module SolidusStores
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions::Decorators

    isolate_namespace ::Spree

    engine_name 'solidus_stores'

    # use rspec for tests
    config.generators { |g| g.test_framework :rspec }

    initializer 'subscriptions_backend' do
      next unless Spree::Backend::Config.respond_to?(:menu_items)

      Spree::Backend::Config.configure do |config|
        config.menu_items <<
          config.class::MenuItem.new(%i[trade_stores], 'home', url: :admin_trade_stores_path)
      end
    end
  end
end
