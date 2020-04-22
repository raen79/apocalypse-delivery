# frozen_string_literal: true

require 'rails_helper'
require 'spree/testing_support/factories/order_factory'

RSpec.describe Spree::Order, type: :model do
  subject(:taxon) { FactoryBot.create(:taxon, taxonomy: taxonomy) }
  let(:taxonomy) { FactoryBot.create(:taxonomy) }

  describe 'picked scopes' do
    context 'when picked' do
      let!(:order) { create(:order, picked_at: Time.zone.now) }

      it 'can be found with picked scope' do
        expect(Spree::Order.picked.pluck(:id)).to eq([order.id])
      end

      it 'cant be found with not_picked scope' do
        expect(Spree::Order.not_picked.pluck(:id)).to eq([])
      end
    end

    context 'when not picked' do
      let!(:order) { create(:order) }

      it 'cant be found with picked scope' do
        expect(Spree::Order.picked.pluck(:id)).to eq([])
      end

      it 'can be found with not_picked scope' do
        expect(Spree::Order.not_picked.pluck(:id)).to eq([order.id])
      end
    end
  end
end
