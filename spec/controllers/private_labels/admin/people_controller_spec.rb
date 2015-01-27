require 'rails_helper'

module PrivateLabels
  module Admin

    RSpec.describe PeopleController do
      it { should be_a PrivateLabels::Admin::BaseController }

      describe 'GET #edit' do
        let(:private_label)           { create(:private_label) }
        let(:admin)                   { create(:confirmed_person) }
        let(:another_admin)           { create(:confirmed_person) }

        before(:each) do
          create(:private_label_person, private_label: private_label, person: admin, admin: true)
          create(:private_label_person, private_label: private_label, person: another_admin, admin: true)

          @request.host = private_label.domain
          sign_in admin
        end

        it 'fetches the right person' do
          get :show, id: another_admin.id
          expect(assigns[:person]).to be(another_admin)
        end
      end
    end

  end # Admin module
end # PrivateLabels module
