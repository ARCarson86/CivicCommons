require 'rails_helper'

module PrivateLabels
  module Admin

    RSpec.describe PeopleController do
      it { should be_a PrivateLabels::Admin::BaseController }

      describe 'GET #index' do
        let(:private_label)         { create(:private_label) }
        let(:other_private_label)   { create(:private_label) }
        let(:other_people)          { create_list(:person, 3) }
        let(:civic_people)          { create_list(:person, 3) }
        let(:people)                { create_list(:person, 3) }
        let(:admin)                 { create(:admin) }

        before(:each) do
          @request.host = private_label.domain
          people.each { |p| create(:private_label_person, person: p, private_label: private_label) }
          other_people.each { |p| create(:private_label_person, person: p, private_label: other_private_label) }
          create(:private_label_person, person: admin, private_label: private_label, admin: true)
          sign_in admin
        end

        it 'fetches only the people in the private label' do
          get :index
          expect(assigns[:people]).to match_array(people)
        end
      end
    end

  end # Admin module
end # PrivateLabels module
