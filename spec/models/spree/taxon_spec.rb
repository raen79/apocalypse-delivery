# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Spree::Taxonomy, type: :model do
  subject(:taxon) { FactoryBot.create(:taxon, taxonomy: taxonomy) }
  let(:taxonomy) { FactoryBot.create(:taxonomy) }

  describe '#locked?' do
    let(:taxonomy) { FactoryBot.create(:taxonomy, locked: locked) }

    subject { taxon.locked? }

    context 'when the taxonomy is not locked' do
      let(:locked) { false }
      it { is_expected.to be_falsy }
    end

    context 'when set to true' do
      let(:locked) { true }
      it { is_expected.to be_truthy }
    end
  end
end
