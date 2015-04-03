require 'rails_helper'

module PrivateLabels

  RSpec.describe PagesController do
    it { should be_a PrivateLabels::ApplicationController }

    let(:private_label)            { create(:private_label) }
    let(:restricted_private_label) { create(:private_label) }
    let!(:page_1)                  { create(:page, private_label: private_label) }
    let!(:page_2)                  { create(:page, private_label: private_label) }
    let!(:restricted_page)         { create(:page, private_label: restricted_private_label) }

    before(:each) do
      Swayze.current_private_label = private_label
    end

    context 'GET #show' do
      it 'should load the correct page' do
        get 'show', id: page_1.id
        expect(assigns[:page]).to eq(page_1)
      end

      it 'should not allow access to pages on other private labels' do
        expect { get 'show', id: restricted_page.id }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

  end

end # PrivateLabels module
