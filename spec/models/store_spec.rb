# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Store, type: :model do
  subject(:store) { FactoryBot.create(:store) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:postcode) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:street_number) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:country) }
    it { should validate_presence_of(:phone_number) }

    it { should validate_uniqueness_of(:name) }

    describe '#is_hub' do
      subject { store.is_hub }

      context 'by default' do
        it { is_expected.to be_truthy }
      end

      context 'when set to false' do
        let(:store) { FactoryBot.create(:store, is_hub: false) }
        it { is_expected.to be_falsy }
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:spree_taxon) }

    describe '#spree_taxon' do
      subject(:spree_taxon) { store.spree_taxon }

      describe '#name' do
        subject(:taxon_name) { spree_taxon.name }
        it { is_expected.to eq(store.name) }

        context 'when store name is changed' do
          subject { store.update(name: new_name) }

          let!(:previous_name) { store.name }
          let(:new_name) { 'New store name' }

          it { expect { subject }.to change { spree_taxon.name }.from(previous_name).to(new_name) }
        end
      end

      context 'when the store is destroyed' do
        before { store.touch }
        subject { store.destroy }

        it { expect { subject }.to change { Spree::Taxon.count }.by(-1) }
      end
    end
  end
end
