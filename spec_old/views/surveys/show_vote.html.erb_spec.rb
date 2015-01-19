require 'spec_helper'
describe '/surveys/show_vote.html.erb' do
  
  def given_a_vote_response_presenter
    @surveyable = stub_model(Issue)
    @survey = stub_model(Vote, :surveyable => @surveyable, :start_date => 1.days.ago.to_date,:end_date => Date.today)
    @survey_options = [stub_model(SurveyOption)]
    @person = stub_model(Person)
    @survey_response_presenter = stub("VoteResponsePresenter", 
      :available_options => @survey_options, 
      :survey => @survey, 
      :survey_response => @survey_response,
      :max_selected_options => 3).as_null_object
      
    view.stub(:current_person).and_return(@person)
  end
  
  def given_a_vote_response_presenter_that_is_not_allowing_votes
    @surveyable = stub_model(Issue)
    @survey = stub_model(Vote, :surveyable => @surveyable, :start_date => 1.days.ago.to_date,:end_date => Date.today)
    @survey_options = [stub_model(SurveyOption)]
    @person = stub_model(Person)
    @survey_response_presenter = stub("VoteResponsePresenter", 
      :available_options => @survey_options, 
      :survey => @survey, 
      :survey_response => @survey_response,
      :allowed? => false,
      :max_selected_options => 3).as_null_object
      
    view.stub(:current_person).and_return(@person)
  end
  
  def given_a_vote_response_presenter_that_is_allowing_votes
    @surveyable = stub_model(Issue)
    @survey = stub_model(Vote, :surveyable => @surveyable, :start_date => 1.days.ago.to_date,:end_date => Date.today)
    @survey_options = [stub_model(SurveyOption)]
    @person = stub_model(Person)
    @survey_response_presenter = stub("VoteResponsePresenter", 
      :available_options => @survey_options, 
      :survey => @survey, 
      :survey_response => @survey_response,
      :allowed? => true,
      :max_selected_options => 3).as_null_object
      
    view.stub(:current_person).and_return(@person)
  end
    
  it "should render the correct header based on what model is @surveyable" do
    given_a_vote_response_presenter
    render
    content_for(:main_body).should render_template("issues/_survey_header")
  end
  
  it "should render the survey options for 'vote'" do
    given_a_vote_response_presenter
    render
    content_for(:main_body).should render_template('survey_options/_survey_option_vote')
  end
  
  it "should display the selected-survey-options div" do
    given_a_vote_response_presenter
    render
    content_for(:main_body).should have_selector('div.selected-survey-options')
  end
  it "should display the survey-options div" do
    given_a_vote_response_presenter
    render
    content_for(:main_body).should have_selector('div.survey-options')
  end
  
  it "should display the vote box multiple times" do
    given_a_vote_response_presenter
    render
    content_for(:main_body).should have_selector('.selected-survey-options .sortable-wrapper',:count => 3)
  end
  
  describe "submit button" do
    it "should be disabled if the voting is not allowed" do
      given_a_vote_response_presenter_that_is_not_allowing_votes
      render
      content_for(:main_body).should have_selector('input.submit[disabled=disabled]')
    end
    it "should NOT be disabled if the voting is allowed" do
      given_a_vote_response_presenter_that_is_allowing_votes
      render
      content_for(:main_body).should_not have_selector('input.submit[disabled=disabled]')
    end
  end
  
end
