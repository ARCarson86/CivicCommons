#passed
require 'spec_helper'

describe SelectedSurveyOption do
  context "Associations" do
    it "should belongs_to survey_response" do
      SelectedSurveyOption.reflect_on_association(:survey_response).macro.should == :belongs_to
    end
    
    it "shold belongs_to survey_option" do
      SelectedSurveyOption.reflect_on_association(:survey_option).macro.should == :belongs_to
    end
  end
  
  context "Validations" do
    context "validates_presence_of" do
      before(:each) do
        @selected_survey_option = SelectedSurveyOption.create
      end
      describe "survey_response_id" do
        it "should validate presence of survey_response_id" do
          @selected_survey_option.errors[:survey_response_id].should == ["can't be blank"]
        end
        it "should not validate presence_of survey_response_id if it is bypassed" do
          @selected_survey_option = SelectedSurveyOption.create(:bypass_presence_validation => true)
          @selected_survey_option.errors[:survey_response_id].should be_blank
        end
      end
      describe "survey_option_id" do
        it "should validate presence of survey_option_id" do
          @selected_survey_option.errors[:survey_option_id].should == ["can't be blank"]
        end
        it "should not validate presence_of survey_response_id if it is bypassed" do
          @selected_survey_option = SelectedSurveyOption.create(:bypass_presence_validation => true)
          @selected_survey_option.errors[:survey_option_id].should be_blank
        end
        
      end
      
    end
    context "validates_uniqueness_of" do
      it "should throw validation error if a selected survey option is created on the same position, survey option, and survey response" do
        @selected_survey_option1 = SelectedSurveyOption.create(:position => 123, :survey_option_id => 123, :survey_response_id => 123)
        @selected_survey_option2 = SelectedSurveyOption.create(:position => 123, :survey_option_id => 123, :survey_response_id => 123)
        @selected_survey_option2.errors[:survey_option_id].should == ["has already been selected"]
      end
    end
  end
  
end