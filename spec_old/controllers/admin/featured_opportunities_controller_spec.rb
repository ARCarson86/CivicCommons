require 'spec_helper'

describe Admin::FeaturedOpportunitiesController do
  
  def stub_person(attributes={})
    @person ||= stub_model(Person, attributes).as_null_object
  end
  
  def mock_featured_opportunity(stubs={})
    @mock_featured_opportunity ||= mock_model(FeaturedOpportunity, stubs).as_null_object
  end

  def mock_conversation(stubs={})
    @mock_conversation ||= mock_model(Conversation, stubs).as_null_object
  end

  def mock_contribution(stubs={})
    @mock_contribution ||= mock_model(Contribution, stubs).as_null_object
  end

  def mock_action(stubs={})
    @mock_action ||= mock_model(Action, stubs).as_null_object
  end

  def mock_reflection(stubs={})
    @mock_reflection ||= mock_model(Reflection, stubs).as_null_object
  end
  
  before(:each) do
    @controller.stub(:verify_admin).and_return(true)
    @controller.stub(:current_person).and_return(stub_person(:admin => true))
  end

  describe "GET 'show'" do
    it "returns http success" do
      FeaturedOpportunity.stub(:find).with('123').and_return(mock_featured_opportunity)
      get 'show', :id => '123'
      response.should be_success
    end
    it "should find the FeaturedOpportunity " do
      FeaturedOpportunity.should_receive(:find).with('123').and_return(mock_featured_opportunity)
      get 'show', :id => '123'
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      FeaturedOpportunity.stub(:find).and_return(mock_featured_opportunity)
      Conversation.stub(:alphabet_ascending_by_title).and_return(mock_conversation)
    end
    it "returns http success" do
      get 'edit', :id => '123'
      response.should be_success
    end
    it "should find the featured opportunity" do
      FeaturedOpportunity.should_receive(:find).and_return(mock_featured_opportunity)
      get 'edit', :id => '123'
    end
    it "should get the conversation" do
      Conversation.should_receive(:conversations_with_actions_and_reflections).and_return(mock_conversation)
      get 'edit', :id => '123'
    end
    it "should build the contribution if it doesn't exist" do
      mock_featured_opportunity.stub!(:contributions).and_return(mock_contribution)
      mock_contribution.should_receive(:length).and_return(0)
      mock_contribution.should_receive(:build)
      get 'edit', :id => '123'
    end
    it "should build the action if it doesn't exit" do
      mock_featured_opportunity.stub!(:actions).and_return(mock_action)
      mock_action.should_receive(:length).and_return(0)
      mock_action.should_receive(:build)
      get 'edit', :id => '123'
    end
    it "should build the reflection if it doesn't exist" do
      mock_featured_opportunity.stub!(:reflections).and_return(mock_reflection)
      mock_reflection.should_receive(:length).and_return(0)
      mock_reflection.should_receive(:build)
      get 'edit', :id => '123'
    end

  end

  describe "GET 'index'" do
    it "returns http success" do
      FeaturedOpportunity.stub(:all).and_return(mock_featured_opportunity)
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'new'" do
    before(:each) do
      FeaturedOpportunity.stub(:new).and_return(mock_featured_opportunity)
      Conversation.stub(:alphabet_ascending_by_title).and_return(mock_conversation)
    end
    it "returns http success" do
      get 'new'
      response.should be_success
    end
    it "should initialize a featured opportunity" do
      FeaturedOpportunity.should_receive(:new).and_return(mock_featured_opportunity)
      get 'new'
    end
    it "should get the conversation" do
      Conversation.should_receive(:conversations_with_actions_and_reflections).and_return(mock_conversation)
      get 'new'
    end
    it "should build the contribution" do
      mock_featured_opportunity.stub!(:contributions).and_return(mock_contribution)
      mock_contribution.should_receive(:build)
      get 'new'
    end
    it "should build the action" do
      mock_featured_opportunity.stub!(:actions).and_return(mock_action)
      mock_action.should_receive(:build)
      get 'new'
    end
    it "should build the reflection" do
      mock_featured_opportunity.stub!(:reflections).and_return(mock_reflection)
      mock_reflection.should_receive(:build)
      get 'new'
    end

  end

  describe "POST 'create'" do
    before(:each) do
      FeaturedOpportunity.stub(:new).and_return(mock_featured_opportunity)
    end
    it "should redirect to show action if valid" do
      mock_featured_opportunity.stub(:save).and_return(true)
      post :create
      response.should redirect_to admin_featured_opportunity_path(mock_featured_opportunity.id)
    end
    it "should render the :new action if invalid" do
      mock_featured_opportunity.stub(:save).and_return(false)
      post :create
      response.should render_template :action => :new
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      FeaturedOpportunity.stub(:find).and_return(mock_featured_opportunity)
    end
    it "should redirect to show action if valid" do
      mock_featured_opportunity.stub(:save).and_return(true)
      put :update, :id => '123'
      response.should redirect_to admin_featured_opportunity_path(mock_featured_opportunity.id)
    end
    it "should render the :new action if invalid" do
      mock_featured_opportunity.stub(:save).and_return(false)
      put :update, :id => '123'
      response.should render_template :action => :edit
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      FeaturedOpportunity.stub(:find).and_return(mock_featured_opportunity)
    end
    it "should redirect to show action if valid" do
      mock_featured_opportunity.should_receive(:destroy)
      delete :destroy, :id => '123'
      response.should redirect_to admin_featured_opportunities_path
    end
  end

  describe "change_conversation_selection" do
    before(:each) do
      Conversation.stub!(:find).and_return(mock_conversation)
    end

    it "should find the conversation" do
      Conversation.should_receive(:find).and_return(mock_conversation)
      get :change_conversation_selection, :conversation_id => 123, :format => :js
    end
    it "should show all the conversation's contributions" do
      mock_conversation.should_receive(:contributions)
      get :change_conversation_selection, :conversation_id => 123, :format => :js
    end
    it "should show all the conversation's actions" do
      mock_conversation.should_receive(:actions)
      get :change_conversation_selection, :conversation_id => 123, :format => :js
    end
    it "should show all the conversation's reflections" do
      mock_conversation.should_receive(:reflections)
      get :change_conversation_selection, :conversation_id => 123, :format => :js
    end
  end


end
