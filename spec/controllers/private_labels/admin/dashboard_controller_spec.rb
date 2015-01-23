require 'rails_helper'

module PrivateLabels
  module Admin

    RSpec.describe DashboardController do
      it 'is a PlController subclass' do
        expect(controller).to be_a(PlController)
      end

      describe 'GET #show' do
        let(:another_private_label) { create(:private_label) }
        let(:private_label)         { create(:private_label) }
        let(:admin_one)             { create(:person) }
        let(:other_person)          { create(:person) }

        before(:each) do
          create(:private_label_person, person: admin_one, private_label: private_label, admin: true)
          @request.host = private_label.domain

          @conversation = create(:conversation, private_label: private_label)
          civic_conversation = create(:conversation)
          another_conversation = create(:conversation, private_label: another_private_label)

          @contribution = create(:contribution, conversation: @conversation, private_label: private_label)
          create(:contribution, conversation: another_conversation, private_label: another_private_label)
          create(:contribution, conversation: civic_conversation)
        end

        it 'fetches only the admins for the current private label' do
          get :show
          expect(assigns[:admins]).to match_array [admin_one]
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
