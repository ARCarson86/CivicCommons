require 'spec_helper'

describe SurveysController do
  
  def mock_person(stubs={})
    @mock_person ||= mock_model(Person, stubs).as_null_object
  end
  
  def mock_survey(stubs={})
    @mock_survey ||= mock_model(Vote,{:surveyable => nil}.merge(stubs)).as_null_object
  end
  
  def mock_issue(stubs={})
    @mock_issue ||= mock_model(Issue, stubs).as_null_object
  end

  def mock_conversation(stubs={})
    @mock_conversation ||= mock_model(Conversation, stubs).as_null_object
  end
  
  before(:each) do
    controller.stub(:current_person).and_return(mock_person)
  end

  describe "GET show" do
    describe "User have not voted yet" do      
      it "should render the show_vote template if it is a 'vote'" do
        Survey.stub(:find).and_return(mock_survey)
        VoteResponsePresenter.stub(:new).and_return(stub(VoteResponsePresenter, :allowed? => true))
        
        get :show, :id => 123
        response.should render_template('surveys/show_vote')
      end
      it "should render the show, that the vote has ended if the vote has ended" do
        
      end
    end
    describe "user not allowed to vote" do
      it "should show progress if show_progress toggle is on" do
        @survey = mock_survey
        @survey.stub!(:show_progress?).and_return(true)
        Survey.stub(:find).and_return(@survey)
        
        @vote_response_presenter = stub(VoteResponsePresenter, :allowed? => false)
        VoteResponsePresenter.stub(:new).and_return(@vote_response_presenter)
        
        get :show, :id => 123
        response.should render_template('surveys/show_vote_show_progress')
        
      end
      it "should not show progress if the show_progress toggle is off" do
        @survey = mock_survey
        @survey.stub!(:show_progress?).and_return(false)
        Survey.stub(:find).and_return(@survey)
        
        @vote_response_presenter = stub(VoteResponsePresenter, :allowed? => false)
        VoteResponsePresenter.stub(:new).and_return(@vote_response_presenter)
        
        get :show, :id => 123
        response.should render_template('surveys/show_vote_hide_progress')
      end
    end
    describe "survey inactive" do
      it "should render the inactive if a survey is inactive " do
        Survey.stub(:find).and_return(mock_survey(:active? => false))
        get :show, :id => 123
        response.should render_template('surveys/show_vote_inactive')
      end
      it "should render normally if survey is active" do
        Survey.stub(:find).and_return(mock_survey(:active? => true))
        VoteResponsePresenter.stub(:new).and_return(stub(VoteResponsePresenter, :allowed? => true))
        get :show, :id => 123
        response.should_not render_template('surveys/show_vote_inactive')
      end
    end
  end
  
  
  describe "find_survey" do
    it "should return the survey" do
      Survey.should_receive(:find).and_return(mock_survey)
      VoteResponsePresenter.stub(:new).and_return(stub(VoteResponsePresenter, :allowed? => true))
      get :show, :id => 123
    end
  end
  
  describe "redirect_to_proper_url" do
    it "should redirect to conversation_vote_url if survey is a surveyable and surveyable is a Conversation" do      
      @survey = mock_survey(:surveyable => mock_conversation, :surveyable_type => 'Conversation', :id => 123)
      Survey.stub(:find).and_return(@survey)
      get :show, :id => 123      
      response.should redirect_to conversation_vote_url(mock_conversation.id, @survey.id)
    end
    
  end
  
  describe "create_response" do
    describe "post" do
      describe "when confirmed" do
        before(:each) do
          Survey.stub(:find).and_return(mock_survey)
          @vote_response_presenter = stub("VoteResponsePresenter", :confirmed? => true)
          VoteResponsePresenter.stub(:new).and_return(@vote_response_presenter)
        end
        it "should render the show action when successfully saved" do
          @vote_response_presenter.should_receive(:save).and_return(true)
          post :create_response, :id => 123, :survey_response_presenter => {}
          response.should render_template(:action => :show)
        end
        
        it "should set flash[:vote_successful] as true when successfully saved" do
          @vote_response_presenter.should_receive(:save).and_return(true)
          post :create_response, :id => 123, :survey_response_presenter => {}
          flash[:vote_successful].should be_true
        end
        
        it "should redirect to show_ template when there is an error" do
          @vote_response_presenter.should_receive(:save).and_return(false)
          post :create_response, :id => 123, :survey_response_presenter => {}
          response.should render_template('show_vote')
        end
      end
      describe "when not confirmed" do
        before(:each) do
          Survey.stub(:find).and_return(mock_survey)
          @vote_response_presenter = stub("VoteResponsePresenter",:confirmed? => false)
          VoteResponsePresenter.stub(:new).and_return(@vote_response_presenter)
        end
        it "should render the vote confirmation partial when format is js" do
          post :create_response, :id => 123, :survey_response_presenter => {}, :format => :js
          response.should render_template('/surveys/_vote_response_confirmation')
        end
        it "should render nothing vote confirmation partial when format is html" do
          post :create_response, :id => 123, :survey_response_presenter => {}, :format => :html
          response.body.should == 'Javascript needs to be turned on to vote'
        end
        
      end
      
    end
  end

  describe "vote_successful" do
    it "should render the correct template" do
      get :vote_successful
      response.should render_template('surveys/vote_successful')
    end
  end
end
