require 'rails_helper'

module PrivateLabels

  RSpec.describe HomepageController do
    render_views
    it { should be_a PrivateLabels::ApplicationController }

    let(:private_label)           { create(:private_label) }

    before(:each) do
      Swayze.current_private_label = private_label
    end

    describe 'GET #show' do
      let(:people)                  { create_list(:confirmed_person, 3) }
      let(:other_people)            { create_list(:confirmed_person, 3) }
      let(:conversations)           { create_list(:conversation, 3) }
      let(:civic_conversations)     { create_list(:conversation, 3) }
      let(:other_conversations)     { create_list(:conversation, 3) }
      let!(:sidebar)                { create(:sidebar, private_label: private_label, content: '<div class="visible-front">should_be_visible</div><div>should_not_be_visible</div>') }

      before(:each) do
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

      it 'shows correct sidebar on homepage' do
        get :show
        
        expect(response.body).to include("should_be_visible")
        expect(response.body).to_not include("should_not_be_visible")
      end
    end

    describe 'GET #contact' do
      let(:message) { PrivateLabels::ContactUsMessage.new }

      before(:each) do
        expect(PrivateLabels::ContactUsMessage).to receive(:new).and_return(message)
      end

      it 'sets up the contact message' do
        get :contact

        expect(assigns[:contact_us_message]).to eq(message)
      end
    end

    describe 'POST #contact' do
      let(:message) { double }

      context 'when the submitted message is valid' do
        it 'sends the email' do
          expect(PrivateLabels::Contact).to receive(:send_contact_email).and_return(message)
          expect(message).to receive(:deliver!)

          post :contact_submit, :contact_us_message => {:name => "Test User", :email => "test.user@example.com", :body => "This is the body"}

          expect(response).to redirect_to private_labels_contact_path
        end
      end

      context 'when the submitted message is invalid' do
        it 're-renders the form' do
          post :contact_submit, :contact_us_message => {:name => "", :email => "", :body => ""}

          expect(response).to render_template(:contact)
        end
      end
    end
  end

end # PrivateLabels module
