require 'spec_helper'

describe '/surveys/_vote_response_confirmation.html.erb' do
  
  before(:each) do
    @survey_response_presenter = stub(VoteResponsePresenter, :max_selected_options => 3)
    @selected_survey_option = stub(SelectedSurveyOption,:title => 'titlehere')
    @survey_response_presenter.stub!(:selected_option).and_return(@selected_survey_option)
    render
  end

  it "should display the voted selections several times" do
    rendered.should have_selector('p .selected_option',:count => 3)
  end
  
  it "should display the titles of the voted selections" do
    rendered.should contain('titlehere')
  end

  it "should have the cancel link" do
    rendered.should have_selector('a.confirm_vote',:href => '')
  end
  it "should have the confirm link" do
    rendered.should have_selector('a.cancel_vote',:href => '')
  end

end
