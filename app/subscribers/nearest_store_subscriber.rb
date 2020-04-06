module NearestStoreSubscriber
  include Spree::Event::Subscriber

  event_action :order_finalized

  def order_finalized(event)
    order = event.payload[:order]
    order.nearest_store = find_nearest_store(order)
    order.save!
  end

  private

  def find_nearest_store(order)
    address = order.ship_address.address1
    address += ", #{order.ship_address.address2}" if order.ship_address.address2.present?
    address += ", #{order.ship_address.city}, #{order.ship_address.zipcode}"

    Store.where(is_hub: true).near(address).first
  end
end
