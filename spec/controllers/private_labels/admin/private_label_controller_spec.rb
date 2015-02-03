require 'rails_helper'

module PrivateLabels
  module Admin

    RSpec.describe PrivateLabelController do
      let(:private_label)           { create(:private_label) }
      let(:admin)                   { create(:confirmed_person) }

      before(:each) do
        Swayze.current_private_label = private_label
        create(:private_label_person, person: admin, private_label: private_label, admin: true)
        sign_in admin
      end

      it { should be_a PrivateLabels::Admin::BaseController }

      describe 'GET #show' do
        it 'renders the correct template' do
          get :show
          expect(response).to render_template(:show)
        end

        it 'gets the current private label' do
          get :show
          expect(assigns[:private_label]).to eq(private_label)
        end
      end

      describe 'GET #edit' do
        it 'renders the correct template' do
          get :edit
          expect(response).to render_template(:edit)
        end

        it 'gets the current private label' do
          get :edit
          expect(assigns[:private_label]).to eq(private_label)
        end
      end

    end

  end # Admin module
end   # PrivateLabels module 
