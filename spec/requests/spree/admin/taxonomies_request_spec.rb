# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Taxonomies Admin', type: :request do
  stub_authorization!

  subject(:body) { response.body }
  let(:parsed_body) { Nokogiri.HTML(body) }

  let!(:store) { FactoryBot.create(:store) }

  let(:locked_taxonomy) { store.taxonomy }
  let!(:editable_taxonomy) { FactoryBot.create(:taxonomy) }

  let!(:editable_taxon) { FactoryBot.create(:taxon, taxonomy: editable_taxonomy) }

  describe 'GET /admin/taxonomies/{id}/edit' do
    context 'when the taxonomy is locked' do
      before { get "/admin/taxonomies/#{locked_taxonomy.id}/edit" }

      it { is_expected.to include(locked_taxonomy.name.titleize) }
      it { is_expected.to include(locked_taxonomy.taxons.first.name) }

      describe 'submit button' do
        subject { parsed_body.at_css('button[type="submit"]') }
        it { is_expected.to be_blank }
      end
    end

    context 'when the taxonomy is editable' do
      before { get "/admin/taxonomies/#{editable_taxonomy.id}/edit" }

      it { is_expected.to include(editable_taxonomy.name.titleize) }
      it { is_expected.to include(editable_taxonomy.taxons.first.name) }

      describe 'submit button' do
        subject { parsed_body.at_css('button[type="submit"]') }
        it { is_expected.to be_present }
      end
    end
  end

  describe 'GET /admin/taxonomies' do
    before { get '/admin/taxonomies' }

    it { is_expected.to include(locked_taxonomy.name) }
    it { is_expected.to include(editable_taxonomy.name) }

    describe 'locked taxonomy' do
      let(:locked_taxonomy_name) { locked_taxonomy.name.titleize }

      describe 'action buttons' do
        subject(:action_buttons) do
          parsed_body.css("tr:contains('#{locked_taxonomy_name}') .actions a")
        end

        describe 'edit button' do
          subject { action_buttons.at_css("a[data-action='edit']") }
          it { is_expected.to be_present }
        end

        describe 'destroy button' do
          subject { action_buttons.at_css("a[data-action='remove']") }
          it { is_expected.to be_blank }
        end

        describe 'count' do
          subject { action_buttons.size }
          it { is_expected.to eq(1) }
        end
      end
    end

    describe 'editable taxonomy' do
      let(:editable_taxonomy_name) { editable_taxonomy.name.titleize }

      describe 'action buttons' do
        subject(:action_buttons) do
          parsed_body.css("tr:contains('#{editable_taxonomy_name}') .actions a")
        end

        describe 'edit button' do
          subject { action_buttons.at_css("a[data-action='edit']") }
          it { is_expected.to be_present }
        end

        describe 'destroy button' do
          subject { action_buttons.at_css("a[data-action='remove']") }
          it { is_expected.to be_present }
        end

        describe 'count' do
          subject { action_buttons.size }
          it { is_expected.to eq(2) }
        end
      end
    end
  end
end
