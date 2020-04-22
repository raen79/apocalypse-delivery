# frozen_string_literal: true

require 'rails_helper'
require 'spree/testing_support/factories/order_factory'

RSpec.describe 'Picklist generator' do
  let!(:store_taxon) { create(:store_root_taxon) }
  let(:origin_store) { create(:our_store, is_hub: false, root_taxon: store_taxon) }
  let(:origin_product) { create(:product, taxons: [origin_store.spree_taxon]) }
  let(:hub_store) { create(:our_store, is_hub: false, root_taxon: store_taxon) }
  let(:hub_product) { create(:product, taxons: [hub_store.spree_taxon]) }

  let!(:origin_order) do
    line_item = create(:line_item, product: origin_product, quantity: 2)
    create(:order, state: 'complete', line_items: [line_item], nearest_store: hub_store)
  end

  let!(:hub_order) do
    line_item = create(:line_item, product: hub_product, quantity: 2)
    create(:order, state: 'complete', line_items: [line_item], nearest_store: hub_store)
  end

  let!(:mixed_order) do
    origin_line_item = create(:line_item, product: origin_product, quantity: 2)
    hub_line_item = create(:line_item, product: hub_product, quantity: 1)
    create(
      :order,
      state: 'complete', line_items: [origin_line_item, hub_line_item], nearest_store: hub_store
    )
  end

  let(:lists) do
    outstanding_orders = Spree::Order.where(state: 'complete').not_picked.all
    OrderPicklists::ListGenerator.generate_lists(outstanding_orders)
  end

  it 'generates origin lists' do
    origin_store_list = lists[:origin_store_orders][origin_store.id][hub_store.id]
    expect(origin_store_list[origin_order.id].map(&:id)).to eq(origin_order.line_items.pluck(:id))
    expect(origin_store_list[mixed_order.id].map(&:id)).to eq(
      mixed_order.line_items.where(quantity: 2).pluck(:id)
    )
  end

  it 'generates hub lists' do
    hub_store_list = lists[:hub_store_orders][hub_store.id]

    expect(hub_store_list[origin_order.id][:proxy_items][origin_store.id].map(&:id)).to eq(
      origin_order.line_items.pluck(:id)
    )
    expect(hub_store_list[hub_order.id][:own_items].map(&:id)).to eq(
      hub_order.line_items.pluck(:id)
    )

    expect(hub_store_list[mixed_order.id][:proxy_items][origin_store.id].map(&:id)).to eq(
      mixed_order.line_items.where(quantity: 2).pluck(:id)
    )
    expect(hub_store_list[mixed_order.id][:own_items].map(&:id)).to eq(
      mixed_order.line_items.where(quantity: 1).pluck(:id)
    )
  end

  it 'generates delivery lists' do
    hub_store_list = lists[:delivery_orders][hub_store.id]

    origin_order_list =
      hub_store_list[origin_order.shipping_address.zipcode][origin_order.id][origin_store.id]
    expect(origin_order_list[:origin_store]).to eq(origin_store)
    expect(origin_order_list[:items].map(&:id)).to eq(origin_order.line_items.pluck(:id))

    hub_order_list = hub_store_list[hub_order.shipping_address.zipcode][hub_order.id][hub_store.id]
    expect(hub_order_list[:origin_store]).to eq(hub_store)
    expect(hub_order_list[:items].map(&:id)).to eq(hub_order.line_items.pluck(:id))

    mixed_order_origin_list =
      hub_store_list[mixed_order.shipping_address.zipcode][mixed_order.id][origin_store.id]
    expect(mixed_order_origin_list[:origin_store]).to eq(origin_store)
    expect(mixed_order_origin_list[:items].map(&:id)).to eq(
      mixed_order.line_items.where(quantity: 2).pluck(:id)
    )

    mixed_order_hub_list =
      hub_store_list[mixed_order.shipping_address.zipcode][mixed_order.id][hub_store.id]
    expect(mixed_order_hub_list[:origin_store]).to eq(hub_store)
    expect(mixed_order_hub_list[:items].map(&:id)).to eq(
      mixed_order.line_items.where(quantity: 1).pluck(:id)
    )
  end
end
