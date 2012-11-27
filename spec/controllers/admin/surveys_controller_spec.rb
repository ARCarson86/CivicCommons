require 'spec_helper'

describe Admin::SurveysController do
  
  before(:each) do
    @controller.stub(:verify_admin).and_return(true)
    @controller.stub(:current_person).and_return(mock_person)
  end

  def mock_person(stubs={})
    @mock_person ||= mock_model(Person, stubs).as_null_object
  end
  
  def mock_survey(stubs={})
    @mock_survey ||= mock_model(Survey, stubs).as_null_object
  end
  
  def mock_response(stubs={})
    @mock_response ||= mock_model(SurveyResponse, stubs).as_null_object
  end
  
  def vote_progress_service_double(stubs={})
    @vote_progress_service_double ||= double(VoteProgressService, stubs).as_null_object
  end
  

  describe "GET index" do
    it "assigns all surveys as @surveys" do
      Survey.stub(:all) { [mock_survey] }
      get :index
      assigns(:surveys).should eq([mock_survey])
    end
  end

  describe "GET show" do
    it "assigns the requested survey as @survey" do
      Survey.stub(:find).with("37") { mock_survey }
      get :show, :id => "37"
      assigns(:survey).should be(mock_survey)
    end
  end

  describe "GET new" do
    it "assigns a new survey as @survey" do
      Survey.stub(:new) { mock_survey }
      get :new
      assigns(:survey).should be(mock_survey)
    end
    it "should defult to Vote, as a Survey STI" do
      @survey = mock_survey
      Survey.stub(:new){ mock_survey(:save => true) }
      @survey.should_receive('type=').and_return('Vote')
      get :new
    end
  end

  describe "GET edit" do
    it "assigns the requested survey as @survey" do
      Survey.stub(:find).with("37") { mock_survey }
      get :edit, :id => "37"
      assigns(:survey).should be(mock_survey)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created survey as @survey" do
        Survey.stub(:new).and_return(mock_survey(:save => true) )
        post :create, :survey => {'these' => 'params'}
        assigns(:survey).should be(mock_survey)
      end
      
      it "should create an STI model based on type" do
        @survey = mock_survey(:save => true,:type => 'Vote')
        Survey.stub(:new).with({'these' => 'params'}).and_return(@survey)
        @survey.should_receive('type=').and_return('Vote')
        post :create, :survey => {'these' => 'params'}
      end

      it "redirects to the created survey" do
        Survey.stub(:new) { mock_survey(:save => true) }
        post :create, :survey => {}
        response.should redirect_to(admin_survey_url(mock_survey))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved survey as @survey" do
        Survey.stub(:new).with({'these' => 'params'}) { mock_survey(:save => false) }
        post :create, :survey => {'these' => 'params'}
        assigns(:survey).should be(mock_survey)
      end

      it "re-renders the 'new' template" do
        Survey.stub(:new) { mock_survey(:save => false) }
        post :create, :survey => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested survey" do
        Survey.stub(:find).and_return(mock_survey)
        mock_survey.should_receive(:save)
        put :update, :id => "37", :survey => {'these' => 'params'}
      end

      it "assigns the requested survey as @survey" do
        Survey.stub(:find) { mock_survey(:save => true) }
        put :update, :id => "1"
        assigns(:survey).should  be(mock_survey)
      end

      it "redirects to the survey" do
        Survey.stub(:find) { mock_survey(:save => true) }
        put :update, :id => "1"
        response.should redirect_to(admin_survey_url(mock_survey))
      end
    end

    describe "with invalid params" do
      it "assigns the survey as @survey" do
        Survey.stub(:find) { mock_survey(:save => false) }
        put :update, :id => "1"
        assigns(:survey).should be(mock_survey)
      end

      it "re-renders the 'edit' template" do
        Survey.stub(:find) { mock_survey(:save => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested survey" do
      Survey.stub(:find).with("37") { mock_survey }
      mock_survey.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the admin_surveys list" do
      Survey.stub(:find) { mock_survey }
      delete :destroy, :id => "1"
      response.should redirect_to(admin_surveys_url)
    end
  end
  
  describe "GET progress" do
    it "assigns the requested survey as @survey" do
      Survey.stub(:find).with("37") { mock_survey }
      get :progress, :id => "37"
      assigns(:survey).should be(mock_survey)
    end
    
    it "gets the survey responses based on last voted" do
      Survey.stub(:find).with("37") { mock_survey }
      mock_survey.stub_chain(:survey_responses, :sort_last_created_first).and_return([mock_response])
      get :progress, :id => "37"
      assigns(:responses).should == [mock_response]
    end
    it "initalizes the Vote Progress service" do
      Survey.stub(:find).with("37") { mock_survey }
      VoteProgressService.should_receive(:new).with(mock_survey)
      get :progress, :id => "37"
    end
  end
  
  describe "GET export_progress" do
    it "assigns the requested survey as @survey" do
      Survey.stub(:find).with("37") { mock_survey }
      VoteProgressService.stub(:new).and_return(vote_progress_service_double)
      get :export_progress, :id => "37"
      assigns(:survey).should be(mock_survey)
    end
    it "initalizes the Vote Progress service" do
      Survey.stub(:find).with("37") { mock_survey }
      VoteProgressService.should_receive(:new).with(mock_survey).and_return(vote_progress_service_double)
      get :export_progress, :id => "37"
    end
    it "it calls the export_to_csv method" do
      Survey.stub(:find).with("37") { mock_survey }
      VoteProgressService.stub(:new).with(mock_survey).and_return(vote_progress_service_double)
      vote_progress_service_double.should_receive(:export_to_csv).and_return([])
      get :export_progress, :id => "37"
    end
    it "should respond with CSV mime type" do
      Survey.stub(:find).with("37") { mock_survey }
      VoteProgressService.stub(:new).with(mock_survey).and_return(vote_progress_service_double)
      get :export_progress, :id => "37"
      response.content_type.should == 'text/csv'
    end
  end
  

end
