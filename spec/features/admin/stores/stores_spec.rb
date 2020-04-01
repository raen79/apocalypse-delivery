# frozen_string_literal: true

require 'spec_helper'

describe 'Stores', type: :feature do
  context 'as admin user' do
    # stub_authorization!

    before(:each) { visit '/admin' }

    context 'listing stores' do
      before do
        create(:store, name: 'Testie')
        create(:store, name: 'Too testie')
      end

      it 'should show a listing of existing stores' do
        click_on 'Stores'

        expect(page).to have_content('Testie')
        expect(page).to have_content('Too testie')
      end
    end
  end
end
