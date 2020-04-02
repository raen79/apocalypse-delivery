# frozen_string_literal: true

require 'rails_helper'

describe 'Stores Admin', type: :feature do
  stub_authorization!

  before(:each) { visit('/admin') }

  describe 'listing page' do
    before do
      create(:store, name: 'Testie')
      create(:store, name: 'Too testie')
    end

    it 'shows existing stores' do
      visit '/admin/trade_stores'

      expect(page).to have_content('Testie')
      expect(page).to have_content('Too testie')
    end
  end

  describe 'new store creation' do
    it 'is accessible from the listing' do
      visit '/admin/trade_stores'

      click_on 'New Store'

      expect(current_path).to eq('/admin/trade_stores/new')
    end

    it 'shows validation errors' do
      visit '/admin/trade_stores/new'
      click_on 'Create'

      expect(page).to have_content('Name can\'t be blank')
    end

    it 'creates a new Store' do
      # Need a starting taxon
      create(:store_root_taxon)

      visit '/admin/trade_stores/new'

      fill_in 'Name', with: 'TestsRUs'
      fill_in 'Email', with: 'tests@testing.com'
      fill_in 'Phone number', with: '999'
      fill_in 'Street', with: 'Seasamee Strasse'
      fill_in 'Street number', with: '123'
      fill_in 'Postcode', with: '10997'
      fill_in 'City', with: 'Berlin'
      fill_in 'Country', with: 'Jermany'

      click_on 'Create'

      expect(page).to have_content('Store created successfully')
    end
  end

  describe 'editing existing store' do
    it 'is editable' do
      tested_store = create(:store, name: 'Testie')

      visit '/admin/trade_stores'
      click_on 'Testie'

      fill_in 'Name', with: 'Testestorn'

      click_on 'Update'

      expect(tested_store.reload.name).to eq('Testestorn')
    end
  end
end
