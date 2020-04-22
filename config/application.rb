# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ApocalypseDelivery
  class Application < Rails::Application
    initializer 'spree.decorators' do |_app|
      config.to_prepare do
        Dir.glob(Rails.root.join('app/**/*_decorator*.rb')) { |path| require_dependency(path) }
      end
    end

    # Load application's view overrides
    initializer 'spree.overrides' do |_app|
      config.to_prepare do
        Dir.glob(Rails.root.join('app/overrides/*.rb')) { |path| require_dependency(path) }
      end
    end

    config.autoload_paths += %w[lib/]

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
