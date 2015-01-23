require 'rails_helper'

module PrivateLabels
  module Admin

    RSpec.describe BaseController do

      it { should be_a PrivateLabels::ApplicationController }

      describe 'authentication' do
        let!(:private_label)          { create(:private_label) }
        let!(:admin)                  { create(:admin) }
        let!(:non_admin)              { create(:confirmed_person) }
        let!(:another_private_label)  { create(:private_label) }
        let!(:another_admin)          { create(:admin) }
        let(:body_content)            { "You hit my index!" }
        before(:each)                 { @request.host = private_label.domain }

        controller do
          def index
            render text: "You hit my index!"
          end
        end

        before(:each) do
          create(:private_label_person, person: admin, private_label: private_label, admin: true) 
          create(:private_label_person, person: another_admin, private_label: another_private_label, admin: true)
          create(:private_label_person, person: non_admin, private_label: private_label, admin: false)
        end

        context 'when a user is not logged in' do
          it 'redirects to the login page' do
            get :index
            expect(response).to redirect_to(new_person_session_path)
          end
        end

        context 'when a non-admin user is logged in' do
          before(:each)         { sign_in non_admin }

          it 'raises a SecurityError' do
            expect { get :index }.to raise_error(SecurityError)
          end
        end

        context 'when an admin user for the private label is logged in' do
          before(:each)         { sign_in admin }

          it 'renders correctly' do
            get :index
            expect(response.body).to eql(body_content)
          end
        end
      end
    end

  end # Admin module
end # PrivateLabels module
