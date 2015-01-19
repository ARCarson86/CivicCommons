require 'spec_helper'

describe ContributionsController do

  describe "responding to DELETE" do
    let(:contribution) { stub_model(Contribution) }
    let(:current_person) { 'Your Mom' }
    before do
        Contribution.stub(:find).and_return(contribution)
    end

    it 'finds the contribution by id' do
      Contribution.should_receive(:find).with("1")
      delete :destroy, id: 1
    end

    context "when able to delete" do
      before do
        contribution.stub(:destroy_by_user) { contribution }
        delete :destroy, id: 1
      end
      it "provides the deleted contribution to the view" do
        assigns(:contribution).should == contribution
      end

      it "removes the contribution" do
        contribution.should have_received(:destroy_by_user).with nil
      end

      it "returns status ok on success" do
        delete :destroy, id: 1, format: :js
        response.status.should == 200
      end
    end

    context "when unable to delete" do
      before do
        contribution.stub(:destroy_by_user) { false }
        contribution.stub(:errors) { [ 'no love', 'just hate'] }
        delete :destroy, id: 1, format: :js
      end
      it "responds with the contributions error messages" do
        pending
        response.body.should == "[\"no love\",\"just hate\"]"
      end
      it "responds with a status of unprocessable entity" do
        pending
        response.status.should == 422
      end
    end
  end

  describe "POST: Update Contribution" do
    let(:conversation) { stub_model(Conversation) }
    let(:contribution) { stub_model(Contribution) }
    let(:current_person) { 'Your Dad' }

    before do
        Conversation.stub(:find).and_return(conversation)
        Contribution.stub(:find).and_return(contribution)

        contribution.stub(:self_and_descendants).and_return([contribution])
    end

    it 'will gather embedly information when a new link/url is set' do
      pending
      subject.should_receive(:fetch_embedly_information)

      post :update, :id => "1150", :conversation_id => "450", contribution: { "1150" => {content: "hello world"}, "url"=>"www.google.com", "contribution_id"=> "1150", "id"=>"1150", :url=>"www.google.com"}
    end
  end

  describe "fb_link" do
    let(:contribution) { stub_model(Contribution, conversation: stub_model(Conversation), :content => '<b>Conversation content here</b>') }

    before(:each) do
      Contribution.stub(:find).and_return(contribution)
    end

    it "should redirect to the conversation's page's node if user agent is not a facebook bot" do
      get :fb_link, id: '1234', conversation_id: 'convo-id-here'
      response.should redirect_to "http://test.host/conversations/#{contribution.conversation.id}#node-#{contribution.id}"
    end
    it "should render the fb_like template if user agent is a facebook bot" do
      request.env['HTTP_USER_AGENT'] = "facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)"
      get :fb_link, id: '1234', conversation_id: 'convo-id-here'
      response.should render_template 'fb_link'
    end
  end

  describe "POST: Create Confirmed Contribution" do

    it "Creates a new contribution" do
      conversation = mock_model(Conversation, id: 1)
      contribution = mock_model(Contribution, conversation: conversation)
      Contribution.stub(:create_node).and_return(contribution)

      post :create_confirmed_contribution, contribution: {content: "hello world", owner: 1, conversation_id: 1}
    end

    it "Redirects to conversation page" do
      conversation = mock_model(Conversation, id: 1)
      contribution = mock_model(Contribution, id: 1, conversation: conversation)
      Contribution.stub(:create_node).and_return(contribution)

      post :create_confirmed_contribution, contribution: {content: "hello world", owner: 1, conversation_id: 1}
      response.should redirect_to '/conversations/1#contribution1'
    end

  end

  context "Within a Conversation" do

    before :each do
      @conversation = FactoryGirl.create(:conversation)
      controller.stub(:load_conversation).and_return(@conversation)
    end

    describe ""

  end

end
