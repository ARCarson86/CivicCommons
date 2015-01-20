require 'spec_helper'

describe VoteResponsePresenter do
  def given_a_person_and_a_survey_and_presenter
    @person = FactoryGirl.create(:registered_user)
    @survey = FactoryGirl.create(:vote)
    @survey_option1 = FactoryGirl.create(:survey_option,:survey_id => @survey.id, :position => 1)
    @presenter = VoteResponsePresenter.new(:person_id => @person.id,:survey_id => @survey.id)
  end
  
  def given_a_person_and_a_survey
    @person = FactoryGirl.create(:registered_user)
    @survey = FactoryGirl.create(:vote, max_selected_options: 3)
    @survey_option1 = FactoryGirl.create(:survey_option,:survey_id => @survey.id, :position => 1)
    @survey_option2 = FactoryGirl.create(:survey_option,:survey_id => @survey.id, :position => 2)
    @survey_option3 = FactoryGirl.create(:survey_option,:survey_id => @survey.id, :position => 3)
  end
  
  
  it "should allow for selected_option_1_id" do
    given_a_person_and_a_survey_and_presenter
    @presenter.selected_option_1_id.should be_nil
  end
  it "should set selected_option_1_id=" do
    given_a_person_and_a_survey_and_presenter
    @presenter.selected_option_1_id = @survey_option1.id
    @presenter.selected_option_1_id.should == @survey_option1.id
  end
  
  it "should have the person" do
    given_a_person_and_a_survey_and_presenter
    @presenter.person.should == @person
  end
  
  it "should have the survey" do
    given_a_person_and_a_survey_and_presenter
    @presenter.survey.should == @survey
  end
  
  it "should have max_selected_options" do
    given_a_person_and_a_survey_and_presenter
    @presenter.max_selected_options.should == 3
  end
  
  it "should return the survey_option object when selected_option_1 is called" do
    given_a_person_and_a_survey_and_presenter
    @presenter.selected_option_1_id = @survey_option1.id
    @presenter.selected_option_1.should == @survey_option1
  end
  
  context "saving" do
    def given_a_vote_presenter
      @person = FactoryGirl.create(:registered_user)
      @survey = FactoryGirl.create(:vote)
      @survey_option1 = FactoryGirl.create(:survey_option,:survey_id => @survey.id, :position => 1)
      @presenter = VoteResponsePresenter.new(:person_id => @person.id,
        :survey_id => @survey.id, 
        :selected_option_1_id => 11, 
        :selected_option_2_id => 22)
    end
    
    def given_a_presenter_with_an_expired_vote
      @person = FactoryGirl.create(:registered_user)
      @survey = FactoryGirl.create(:vote, :end_date => 2.days.ago)
      @survey_option1 = FactoryGirl.create(:survey_option,:survey_id => @survey.id, :position => 1)
      @presenter = VoteResponsePresenter.new(:person_id => @person.id,
        :survey_id => @survey.id, 
        :selected_option_1_id => 11, 
        :selected_option_2_id => 22)
    end
    
    def given_a_bare_vote_presenter
      @person = FactoryGirl.create(:registered_user)
      @survey = FactoryGirl.create(:vote)
      @survey_option1 = FactoryGirl.create(:survey_option,:survey_id => @survey.id, :position => 1)
      @presenter = VoteResponsePresenter.new(:person_id => @person.id,
        :survey_id => @survey.id)
    end
    
    it "should correctly save the survey_response" do
      given_a_vote_presenter
      @presenter.save
      @presenter.should be_persisted
      @presenter.survey_response.should be_persisted
    end
    
    it "should correctly save the selected_survey_options when associating using the ids" do
      given_a_vote_presenter
      @presenter.selected_option_1_id.should == 11
      @presenter.selected_option_2_id.should == 22
      @presenter.save
      @presenter.selected_survey_option_1.should be_persisted
      @presenter.selected_survey_option_2.should be_persisted
    end
    
    it "should correctly save the selected_survey_options when associating using the object" do
      given_a_bare_vote_presenter
      @presenter.selected_option_1 = @survey_option1
      @presenter.save
      @presenter.selected_survey_option_1.should be_persisted
    end
    
    it "should not define more than the maximum selected_survey_options" do
      given_a_vote_presenter
      defined?(@presenter.selected_option_99).should be_false
    end
    
    it "should destroy the selected_survey_option record if selected_option is blank" do
      given_a_vote_presenter
      @presenter.save
      @presenter.selected_option_1_id.should == 11
      
      @presenter = VoteResponsePresenter.new(:person_id => @person.id,
        :survey_id => @survey.id, :selected_option_1_id => nil)  
      @presenter.save
      @presenter.selected_option_1_id.should be_blank
      @presenter.selected_survey_option_1.should be_destroyed
    end
    
    context "already_voted?" do
      
      it 'should return true if survey response has already persisted' do
        given_a_vote_presenter
        @presenter.save
        @presenter.already_voted?.should be_true
      end
      it "should return false if survey response is not persisted" do
        given_a_vote_presenter
        @presenter.already_voted?.should be_false
      end
    end
    
    context "allowed?" do
      it "should be true if user has not already_voted yet" do
        given_a_vote_presenter
        @presenter.should be_allowed
      end
      it "should not be true if survey has not expired yet" do
        given_a_presenter_with_an_expired_vote
        @presenter.should_not be_allowed
      end
    end
    
    context "available options" do
      it "should show the available survey options what is remaining" do
        given_a_person_and_a_survey_and_presenter
        @presenter.available_options.should == [@survey_option1]
      end      
    end

    context "selected options" do
      it "should show the available survey options what is remaining" do
        given_a_person_and_a_survey_and_presenter
        @presenter.selected_option_1_id = @survey_option1.id
        @presenter.selected_option(1).should == @survey_option1
      end      
    end
    
    context "only_one_selected_option?" do
      it "should return true if selected option is one" do
        given_a_person_and_a_survey
        @presenter = VoteResponsePresenter.new(:person_id => @person.id,:survey_id => @survey.id, selected_option_ids:[@survey_option1.id])
        @presenter.should be_only_one_selected_option
      end
      it "should return false if it's zero" do
        given_a_person_and_a_survey
        @presenter = VoteResponsePresenter.new(:person_id => @person.id,:survey_id => @survey.id)
        @presenter.should_not be_only_one_selected_option
      end
      it "should return false if it's more than one" do
        given_a_person_and_a_survey
        @presenter = VoteResponsePresenter.new(:person_id => @person.id,:survey_id => @survey.id, selected_option_ids: [@survey_option1.id, @survey_option2.id])
        @presenter.should_not be_only_one_selected_option
      end
      
    end

    
    context "confirmed?" do
      it "should return false if there is no confirmed parameter" do
        given_a_vote_presenter
        @presenter.confirmed?.should be_false
      end
      it "should return true if there is a confirmed param" do
        given_a_vote_presenter
        @presenter = VoteResponsePresenter.new(:person_id => @person.id,
          :survey_id => @survey.id, :selected_option_1_id => nil, 
          :confirmed => true)
            
        @presenter.confirmed?.should be_true
      end
    end
  end
end