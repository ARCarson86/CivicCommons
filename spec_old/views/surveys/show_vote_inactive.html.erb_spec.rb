require 'spec_helper'
describe '/surveys/show_vote_inactive.html.erb' do
  
  def given_an_inactive_vote
    @surveyable = stub_model(Issue)
    @survey = stub_model(Vote, :surveyable => @surveyable, :active? => false)
    @person = stub_model(Person)
    view.stub(:current_person).and_return(@person)
  end
  
  # def given_a_vote_response_presenter_that_is_persisted
  #   @surveyable = stub_model(Issue)
  #   @survey = stub_model(Vote, :surveyable => @surveyable)
  #   @survey_options = [stub_model(SurveyOption)]
  #   @person = stub_model(Person)
  #   @survey_response_presenter = stub("VoteResponsePresenter", 
  #     :available_options => @survey_options, 
  #     :survey => @survey, 
  #     :survey_response => @survey_response,
  #     :already_voted? => true,
  #     :max_selected_options => 3).as_null_object
  #     
  #   view.stub(:current_person).and_return(@person)
  #   
  #   @vote_progress_service = stub('VoteProgressService')
  # end
    
  it "should display the message that survey is not active" do
    given_an_inactive_vote
    render
    content_for(:main_body).should contain 'This Ballot is not available at this moment'
    content_for(:main_body).should contain 'Please come back again on or after false'
  end
    
end
