Spree::Backend::Config.configure do |config|
  config.menu_items <<
    config.class::MenuItem.new(%i[trade_stores], 'home', url: '/admin/trade_stores')
end
