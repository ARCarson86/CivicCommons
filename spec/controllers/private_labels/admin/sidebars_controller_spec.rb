require 'rails_helper'

module PrivateLabels
  module Admin

    RSpec.describe SidebarsController, type: :controller do
      it { should be_a PrivateLabels::Admin::BaseController }

      context 'GET #edit' do

        let(:private_label) { create(:private_label) }
        let(:admin) { create :confirmed_person }

        before(:each) do
          @request.host = private_label.domain
          create(:private_label_person, person: admin, private_label: private_label, admin: true)
          sign_in admin
        end

        context 'when the private label already has a persisted sidebar' do
          let!(:sidebar) { create :sidebar, private_label: private_label }

          it 'fetches the private labels\'s if present' do
            get 'edit'
            expect(assigns(:sidebar)).to eq(sidebar)
          end
        end

        context 'when the private label does not yet have a sidebar' do
          let(:sidebar) { build :sidebar, private_label: private_label, content: nil }

          it 'builds a new sidebar object' do
            get 'edit'
            expect(assigns(:sidebar).attributes).to eq(sidebar.attributes)
          end

        end

      end

      context 'POST #create' do

        let(:private_label) { create(:private_label) }
        let(:admin) { create :confirmed_person }

        before(:each) do
          @request.host = private_label.domain
          create(:private_label_person, person: admin, private_label: private_label, admin: true)
          sign_in admin
        end

        it 'creates a sidebar for the private label' do
          post 'create', private_labels_sidebar: { content: 'Test sidebar content' }
          expect(assigns(:sidebar)).to be_persisted
          expect(assigns(:sidebar).content).to eq('Test sidebar content')
          expect(response).to redirect_to(private_labels_admin_root_path)
        end

      end

      context 'PUT #update' do

        let(:private_label) { create(:private_label) }
        let(:admin) { create :confirmed_person }

        before(:each) do
          @request.host = private_label.domain
          create(:private_label_person, person: admin, private_label: private_label, admin: true)
          sign_in admin
        end

        it 'creates a sidebar for the private label' do
          put 'update', private_labels_sidebar: { content: 'Test sidebar content' }
          expect(assigns(:sidebar)).to be_persisted
          expect(assigns(:sidebar).content).to eq('Test sidebar content')
          expect(response).to redirect_to(private_labels_admin_root_path)
        end

      end

    end

  end # Admin module
end # PrivateLabels module
