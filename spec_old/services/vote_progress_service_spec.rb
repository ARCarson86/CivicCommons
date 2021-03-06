require 'spec_helper'

describe VoteProgressService do
  
  def given_a_vote
    @person1 = FactoryGirl.create(:registered_user)
    @person2 = FactoryGirl.create(:registered_user)
    @survey = FactoryGirl.create(:vote, :max_selected_options => 3)
    @survey_option1 = FactoryGirl.create(:survey_option,:survey_id => @survey.id, :position => 1)
    @survey_option2 = FactoryGirl.create(:survey_option,:survey_id => @survey.id, :position => 2)
    @survey_option3 = FactoryGirl.create(:survey_option,:survey_id => @survey.id, :position => 3)
    @survey_option4 = FactoryGirl.create(:survey_option,:survey_id => @survey.id, :position => 4)
    @survey_option5 = FactoryGirl.create(:survey_option,:survey_id => @survey.id, :position => 5)
    @survey_option6 = FactoryGirl.create(:survey_option,:survey_id => @survey.id, :position => 6)
  end
  
  def given_valid_vote_responses
    given_a_vote
    @presenter1 = VoteResponsePresenter.new(:person_id => @person1.id,
      :survey_id => @survey.id, 
      :selected_option_1_id => @survey_option1.id)
    @presenter1.save
    @presenter2 = VoteResponsePresenter.new(:person_id => @person2.id,
      :survey_id => @survey.id, 
      :selected_option_1_id => @survey_option1.id, 
      :selected_option_2_id => @survey_option2.id)
    @presenter2.save
  end
  
  def given_a_vote_progress_service
    given_valid_vote_responses
    @vote_progress_service = VoteProgressService.new(@survey)
  end
  
  def given_a_vote_progress_service_with_no_responses
    given_a_vote
    @vote_progress_service = VoteProgressService.new(@survey)
  end
  
  describe "calculate_selected_survey_options" do
    before(:each) do
      given_valid_vote_responses
      @selected_survey_option = VoteProgressService.new(@survey).calculate_selected_survey_options.first
    end
    it "should return the correct number of results" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).calculate_selected_survey_options.length.should == 3
    end
    it "should return survey_id" do
      given_valid_vote_responses
      @selected_survey_option.attributes['survey_id'].should_not be_nil
    end
    it "should return person_id" do
      given_valid_vote_responses
      @selected_survey_option.attributes['person_id'].should_not be_nil
    end
    it "should return first_name" do
      given_valid_vote_responses
      @selected_survey_option.attributes['first_name'].should_not be_nil
    end
    it "should return last_name" do
      given_valid_vote_responses
      @selected_survey_option.attributes['last_name'].should_not be_nil
    end
    it "should return email" do
      given_valid_vote_responses
      @selected_survey_option.attributes['email'].should_not be_nil
    end
    it "should return date_voted" do
      given_valid_vote_responses
      @selected_survey_option.attributes['date_voted'].should_not be_nil
    end
    it "should return survey_option_id" do
      given_valid_vote_responses
      @selected_survey_option.attributes['survey_option_id'].should_not be_nil
    end
    it "should return title" do
      given_valid_vote_responses
      @selected_survey_option.attributes['title'].should_not be_nil
    end
    it "should return weight" do
      given_valid_vote_responses
      @selected_survey_option.attributes['weight'].should_not be_nil
    end
  end
  
  describe "calculate_progress" do
    it "should return the correct number of results" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).calculate_progress.count.should == 6
    end
    it "should return the description attribute" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).calculate_progress.first.attributes['description'].should_not be_nil
    end
    it "should return the survey_id attribute" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).calculate_progress.first.attributes['survey_id'].should_not be_nil
    end
    it "should return the survey_option_id attribute" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).calculate_progress.first.attributes['survey_option_id'].should_not be_nil
    end
    it "should return the title attribute" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).calculate_progress.first.attributes['title'].should_not be_nil
    end
    it "should return the total_votes attribute" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).calculate_progress.first.attributes['total_votes'].should_not be_nil
    end
    it "should return the weighted_votes attribute" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).calculate_progress.first.attributes['weighted_votes'].should_not be_nil
    end
    
    it "should return the correct total votes" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).calculate_progress.first.total_votes.to_i.should == 2
    end
    it "should return the correct weighted votes" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).calculate_progress.first.weighted_votes.to_i.should == 6
    end
    it "should order by the highest weighted votes first" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).calculate_progress.first.weighted_votes.to_i.should == 6
      VoteProgressService.new(@survey).calculate_progress.last.weighted_votes.to_i.should == 0
    end
  end
  
  describe "setting an :voted flag, to return if that option has been voted by a particular user or not" do
    it "should set it to true if there is a voter" do
      given_valid_vote_responses
      vote_progress_service = VoteProgressService.new(@survey,@person2).progress_result.collect(&:voted)
      vote_progress_service[0].should == true
      vote_progress_service[1].should == true
    end
    it "should not set the :voted if there is no voter" do
      given_valid_vote_responses
      vote_progress_service = VoteProgressService.new(@survey).progress_result.collect(&:voted)
      vote_progress_service.all?{|record| record == nil}.should be_true
    end
    
  end
  
  describe "calculate_weighted_votes_percentage" do
    it "should set each survey_options with 'weighted_votes_percentage'" do
      given_a_vote_progress_service
      @vote_progress_service.progress_result.first.weighted_votes_percentage.should be_an_instance_of(Fixnum)
    end
    it "should set each survey_option's winner field with true if they are under the max_selected_votes" do
      given_a_vote_progress_service
      @vote_progress_service.progress_result.first.winner.should be_true
      @vote_progress_service.progress_result.last.winner.should be_false
    end
    it "should not break when there are no survey responses" do
      given_a_vote_progress_service_with_no_responses
      @vote_progress_service.highest_weighted_votes_percentage.should == 0
    end
  end
  
  describe "calculate_total_weighted_votes" do
    it "should correctly sum the total weighted_votes" do
      given_a_vote_progress_service
      @vote_progress_service.calculate_total_weighted_votes.should == 8
    end
  end
  
  describe "total_weighted_votes" do
    it "should correctly sum the total weighted_votes" do
      given_a_vote_progress_service
      @vote_progress_service.total_weighted_votes.should == 8
    end
  end
  
  describe "format_data" do
    it "should correctly format an empty array" do
      VoteProgressService.format_data([]).should == []
    end
    it "should correctly format a 1 length array into a 1 dimensional array" do
      VoteProgressService.format_data([1]).should == [[1]]
    end
    
    it "should correctly format a 2 length array into a 2 dimensional array" do
      VoteProgressService.format_data([1,2]).should == [[1,0],[0,2]]
    end
    
    it "should correctly format a 3 length array into a 3 dimensional array" do
      VoteProgressService.format_data([1,2,3]).should == [[1,0,0],[0,2,0],[0,0,3]]
    end
  end
  
  describe "formatted_weigthed_votes" do
    it "should call the format_data" do
      given_valid_vote_responses
      VoteProgressService.should_receive(:format_data)
      VoteProgressService.new(@survey).formatted_weigthed_votes
    end
  end
  
  describe "render_chart" do
    it "should correctly display the google chart url" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).render_chart.should =~ /http:\/\/chart.apis.google.com\/chart/i
    end
  end
  
  describe "export_to_csv" do
    # Vote Option,Weighted Vote (percentage)/i
    it "should have Vote Title header" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).export_to_csv.should =~ /Vote Title/i
    end
    it "should have Vote Option header" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).export_to_csv.should =~ /Vote Option/i
    end
    it "should have Weighted Voteheader" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).export_to_csv.should =~ /Weighted Vote \(percentage\)/i
    end
    it "should contain Vote Title column" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).export_to_csv.should =~ /This is a title/i
    end
    it "should contain Vote Option column" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).export_to_csv.should =~ /my Title/i
    end
    
    it "should contain Weighted Vote column" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).export_to_csv.should =~ /75/i
    end
  end
  
  describe "export_selected_survey_options_to_csv" do
    it "should have Vote Title header" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).export_selected_survey_options_to_csv.should =~ /Vote Title/i
    end
    it "should have Voter" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).export_selected_survey_options_to_csv.should =~ /Voter/i
    end
    it "should have Email" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).export_selected_survey_options_to_csv.should =~ /Email/i
    end
    it "should have Date Voted" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).export_selected_survey_options_to_csv.should =~ /Date Voted/i
    end
    it "should have Selection ID" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).export_selected_survey_options_to_csv.should =~ /Selection ID/i
    end
    it "should have Selection" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).export_selected_survey_options_to_csv.should =~ /Selection/i
    end
    it "should have Weight" do
      given_valid_vote_responses
      VoteProgressService.new(@survey).export_selected_survey_options_to_csv.should =~ /Weight/i
    end
  end
  
end
