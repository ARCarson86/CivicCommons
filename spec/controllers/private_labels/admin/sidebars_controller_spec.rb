require 'rails_helper'

module PrivateLabels
  module Admin

    RSpec.describe SidebarsController, type: :controller do
      it { should be_a PrivateLabels::Admin::BaseController }

      describe 'GET #show' do
        let(:private_label) { create(:private_label) }
        let(:admin) { create :confirmed_person }
        let!(:sidebar) { create :sidebar, private_label: private_label }

        before(:each) do
          @request.host = private_label.domain
          create(:private_label_person, person: admin, private_label: private_label, admin: true)
          sign_in admin
        end

        it 'fetches the current sidebar' do
          get 'show'
          expect(assigns(:sidebar)).to eq(sidebar)
        end

      end
    end

  end # Admin module
end # PrivateLabels module
