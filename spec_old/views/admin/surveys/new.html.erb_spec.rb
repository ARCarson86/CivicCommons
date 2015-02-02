require 'spec_helper'

describe "admin/surveys/new.html.erb" do
  before(:each) do
    @survey = mock_model(Survey,
      :id => nil,
      :surveyable_id => 1,
      :surveyable_type => "MyString",
      :tye => 'classType',
      :title => "MyString",
      :show_progress => true,
      :description => "MyText",
      :options => [ mock_model(SurveyOption).as_null_object]
    ).as_null_object
    @survey.stub(:new_record?).and_return(true)
    assign(:survey, @survey) 
  end

  it "renders new survey form" do
    render
    rendered.should have_selector("form", :action => admin_surveys_path, :method => "post") do |form|
      form.should_not have_selector("input#survey_surveyable_id", :name => "survey[surveyable_id]")
      form.should_not have_selector("select#survey_surveyable_type", :name => "survey[surveyable_type]")
      form.should have_selector("input#survey_title", :name => "survey[title]")
      form.should have_selector("textarea#survey_description", :name => "survey[description]")
      form.should have_selector("input#survey_max_selected_options", :name => "survey[max_selected_options]")
      form.should have_selector("select#survey_type", :name => "survey[type]")
      form.should have_selector("input#survey_show_progress", :name => "survey[show_progress]")
      
      #survey options
      form.should have_selector("input#survey_options_attributes_0_title", :name => "survey[options_attributes][0][title]")
      form.should have_selector("input#survey_options_attributes_0_nested", :name => "survey[options_attributes][0][nested]")
      form.should have_selector("input#survey_options_attributes_0_position", :name => "survey[options_attributes][0][position]")
    end
  end
end
