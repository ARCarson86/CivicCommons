require 'rails_helper'

module PrivateLabels

  RSpec.describe HomepageController do
    it { should be_a PrivateLabels::ApplicationController }

    describe 'GET #show' do
      let(:private_label)           { create(:private_label) }
      let(:people)                  { create_list(:confirmed_person, 3) }
      let(:other_people)            { create_list(:confirmed_person, 3) }
      let(:conversations)           { create_list(:conversation, 3) }
      let(:civic_conversations)     { create_list(:conversation, 3) }
      let(:other_conversations)     { create_list(:conversation, 3) }

      before(:each) do
        @request.host = private_label.domain
        other_private_label = create(:private_label)

        people.each { |p| create(:private_label_person, person: p, private_label: private_label) }
        other_people.each { |p| create(:private_label_person, person: p, private_label: other_private_label) }

        conversations.each { |c| c.update_attribute(:private_label_id, private_label.id) }
        other_conversations.each { |c| c.update_attribute(:private_label_id, other_private_label.id) }
      end

      it 'fetches all of the people associated with the private label' do
        get :show
        expect(assigns[:people]).to match_array(people)
      end

      it 'does not fetch people associated with other private labels' do
        get :show
        other_people.each { |person| expect(assigns[:people]).not_to include(person) }
      end

      it 'fetches all of the conversations associated with the private label' do
        get :show
        expect(assigns[:conversations]).to match_array(conversations)
      end

      it 'does not fetch civic conversations' do
        get :show
        civic_conversations.each { |c| expect(assigns[:people]).not_to include(c) }
      end

      it 'does not fetch conversations for other private labels' do
        get :show
        other_conversations.each { |c| expect(assigns[:people]).not_to include(c) }
      end
    end
  end

end # PrivateLabels module
