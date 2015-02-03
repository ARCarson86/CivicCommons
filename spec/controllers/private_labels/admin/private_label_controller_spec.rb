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
      end

    end

  end # Admin module
end   # PrivateLabels module 
