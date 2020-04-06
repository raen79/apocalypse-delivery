# frozen_string_literal: true

require 'rails_helper'

require 'spree/testing_support/factories/order_factory'

RSpec.describe 'Nearest Store Subscriber' do
  let!(:store) do
    Geocoder::Lookup::Test.add_stub(
      "116 Reichenberger Str., Berlin, 10999", [
        { 'coordinates'  => [40.7143528, -74.0059731] }
      ]
    )
    create(:our_store, is_hub: true)
  end

  let!(:order) do
    Geocoder::Lookup::Test.add_stub(
      "123 Seasame street, Northwest, Herndon, 666", [
        { 'coordinates'  => [40.7143528, -74.005972] }
      ]
    )

    address = create(:address,  address1: '123 Seasame street', zipcode: '666')
    create(:order, ship_address: address)
  end

  it 'finds the nearest store' do
    order.finalize!
    Spree::Event.fire 'order_finalized', order: order

    expect(order.nearest_store).to eq(store)
  end
end