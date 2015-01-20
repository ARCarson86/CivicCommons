require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the SurveysHelper. For example:
#
# describe SurveysHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe SurveysHelper do
  describe "relative_weighted_votes_percentage" do
    it "should correctly calculate the relative wighted votes percentage" do
      helper.relative_weighted_votes_percentage(5,10).should == 50
    end
    it "should allow offsetting" do
      helper.relative_weighted_votes_percentage(5,10,-10).should == 40
      helper.relative_weighted_votes_percentage(5,10,10).should == 60
    end
    it "should not offset if it results in negative" do
      helper.relative_weighted_votes_percentage(5,10,-60).should == 50
    end
    it "should not break when it's zero" do
      helper.relative_weighted_votes_percentage(0,0).should == 0
    end
  end
  
  describe "polymorphic_survey_url" do
    it "should point to regular vote_url if it's a Vote that has no surveyable" do
      @survey = FactoryGirl.build(:vote, :id => 123)
      helper.polymorphic_survey_url(@survey).should == "http://test.host/votes/123"
    end
    it "should point to conversation_vote_url if it is a vote and the surveyable is a conversation" do
      @conversation = FactoryGirl.create(:conversation)
      @survey = FactoryGirl.create(:vote, :id => 123, :surveyable => @conversation)
      helper.polymorphic_survey_url(@survey).should =~ /\/conversations\/some-random-title-.*\/votes\/123#opportunity-nav/
    end
  end
end
