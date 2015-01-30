require 'spec_helper'
describe '/surveys/show_vote_show_progress.html.erb' do

  before(:each) do
    stub_template('subscriptions/_subscription.html.erb' => 'rendering subscription')
  end

  def given_a_vote_response_presenter_that_is_persisted
    @surveyable = stub_model(Issue)
    @survey = stub_model(Vote, :surveyable => @surveyable)
    @survey_options = [stub_model(SurveyOption)]
    @person = stub_model(Person)
    @survey_response_presenter = stub("VoteResponsePresenter",
      :available_options => @survey_options,
      :survey => @survey,
      :survey_response => @survey_response,
      :already_voted? => true,
      :max_selected_options => 3).as_null_object

    view.stub(:current_person).and_return(@person)

    @vote_progress_service = stub('VoteProgressService', :progress_result => @survey_options, :highest_weighted_votes_percentage => 10)
  end

  it "should render the progress" do
    given_a_vote_response_presenter_that_is_persisted
    render
    content_for(:main_body).should render_template("issues/_survey_header")
  end

  it "should display the vote_successful colorbox if the user have previously voted" do
    given_a_vote_response_presenter_that_is_persisted
    flash[:vote_successful] = true
    render
    content_for(:header).should contain "$.colorbox({href:'/votes/vote_successful', opacity: 0.5})"
  end

  it "should NOT display the vote_successful colorbox if the user have previously voted" do
    given_a_vote_response_presenter_that_is_persisted
    flash[:vote_successful] = false
    render
    content_for(:header).should_not contain "$.colorbox({href:'/votes/vote_successful', opacity: 0.5})"
  end


end
