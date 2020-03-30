# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Spree::Taxonomy, type: :model do
  subject(:taxonomy) { FactoryBot.create(:taxonomy) }

  describe '#locked?' do
    subject { taxonomy.locked? }

    context 'by default' do
      it { is_expected.to be_falsy }
    end

    context 'when set to true' do
      let(:taxonomy) { FactoryBot.create(:taxonomy, locked: true) }
      it { is_expected.to be_truthy }
    end
  end

  describe '#locked' do
    subject { taxonomy.locked }

    context 'by default' do
      it { is_expected.to be_falsy }
    end

    context 'when set to true' do
      let(:taxonomy) { FactoryBot.create(:taxonomy, locked: true) }
      it { is_expected.to be_truthy }
    end
  end
end
