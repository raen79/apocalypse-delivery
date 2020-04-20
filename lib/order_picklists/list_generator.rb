# frozen_string_literal: true

# rubocop:disable  Metrics/MethodLength, Metrics/AbcSize

class OrderPicklists
  class ListGenerator
    def self.generate_lists(orders)
      store_taxonomy = Spree::Taxonomy.find_by(name: Store::TAXONOMY_NAME)

      origin_store_orders = {}
      hub_store_orders = {}
      delivery_orders = {}

      orders.each do |order|
        line_items_with_stores =
          order.line_items.includes(product: { taxons: :store }).where(
            spree_taxons: { taxonomy_id: store_taxonomy.id }
          )
        nearest_store = order.nearest_store

        process_origin_store_items(
          origin_store_orders,
          order,
          nearest_store,
          line_items_with_stores
        )
        process_hub_store_items(hub_store_orders, order, nearest_store, line_items_with_stores)
        process_delivery_items(delivery_orders, order, nearest_store, line_items_with_stores)
      end

      {
        origin_store_orders: origin_store_orders,
        hub_store_orders: hub_store_orders,
        delivery_orders: delivery_orders
      }
    end

    def self.process_origin_store_items(origin_store_orders, order, nearest_store, line_items)
      line_items.each do |line_item|
        line_item_store = line_item.product.taxons.first.store
        next if line_item_store.id == nearest_store.id

        origin_store_hash = origin_store_orders[line_item_store.id] ||= {}
        destination_store_hash = origin_store_hash[nearest_store.id] ||= {}
        order_array = destination_store_hash[order.id] ||= []
        order_array << line_item
      end
    end

    def self.process_hub_store_items(hub_store_orders, order, nearest_store, line_items)
      destination_store_hash = hub_store_orders[nearest_store.id] ||= {}
      order_hash = destination_store_hash[order.id] ||= { own_items: [], proxy_items: {} }
      line_items.each do |line_item|
        line_item_store = line_item.product.taxons.first.store
        if line_item_store.id == nearest_store.id
          order_hash[:own_items] << line_item
        else
          proxy_order_array = order_hash[:proxy_items][line_item_store.id] ||= []
          proxy_order_array << line_item
        end
      end
    end

    def self.process_delivery_items(delivery_orders, order, nearest_store, line_items)
      store_hash = delivery_orders[nearest_store.id] ||= {}
      zipcode_hash = store_hash[order.shipping_address.zipcode] ||= {}
      order_hash = zipcode_hash[order.id] ||= {}
      line_items.each do |line_item|
        line_item_store = line_item.product.taxons.first.store
        origin_array =
          order_hash[line_item_store.id] ||= { origin_store: line_item_store, items: [] }
        origin_array[:items] << line_item
      end
    end
  end
end

# rubocop:enable  Metrics/MethodLength, Metrics/AbcSize
