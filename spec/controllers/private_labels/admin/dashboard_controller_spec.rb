require 'rails_helper'

module PrivateLabels
  module Admin

    RSpec.describe DashboardController do
      it 'is a BaseController subclass' do
        expect(controller).to be_a(PrivateLabels::Admin::BaseController)
      end

      describe 'GET #show' do
        let(:another_private_label) { create(:private_label) }
        let(:private_label)         { create(:private_label) }
        let(:admin)                 { create(:confirmed_person) }

        before(:each) do
          Swayze.current_private_label = private_label
          create(:private_label_person, person: admin, private_label: private_label, admin: true)
          sign_in admin

          @conversation = create(:conversation, private_label: private_label)
          civic_conversation = create(:conversation)
          another_conversation = create(:conversation, private_label: another_private_label)

          @contribution = create(:contribution, contributable: @conversation, private_label: private_label)
          create(:contribution, contributable: another_conversation, private_label: another_private_label)
          create(:contribution, contributable: civic_conversation)
        end

        it 'fetches only the admins for the current private label' do
          get :show
          expect(assigns[:admins]).to match_array [admin]
        end

        it 'fetches only the conversations for the private label' do
          get :show
          expect(assigns[:conversations]).to match_array [@conversation]
        end

        it 'fetches only the contributions for the private label' do
          get :show
          expect(assigns[:contributions]).to match_array [@contribution]
        end
      end
    end

  end
end
