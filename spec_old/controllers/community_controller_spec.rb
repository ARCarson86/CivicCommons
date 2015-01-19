require 'spec_helper'

describe CommunityController do
  def mock_person
    @person ||= mock_model(Person).as_null_object
  end
  def mock_issue
    @issue ||= mock_model(Issue).as_null_object
  end
  describe "index" do
    it "should be successful" do
      get :index
      response.should be_success
    end
    it "should order the people" do
      controller.should_receive(:ordered_people)
      controller.should_receive(:filtered_people)
      controller.should_receive(:paginated_people)
      get :index
    end
    it "should get all region" do
      Region.should_receive(:all)
      get :index
    end
    it "should not find the Issue if params[:issue_id] is not existing" do
      Issue.should_not_receive(:find)
      get :index
    end
    context "on issue_id being available" do
      it "should find the Issue" do
        Issue.should_receive(:find)
        get :index, :issue_id => 1
      end
    end
  end

  describe "Filtered based on organization or people" do
    context "with people" do
      it "should be only return people" do
        Person.should_receive(:find_confirmed_order_by_recency).and_return(mock_person)
        mock_person.should_receive(:only_people).and_return(mock_person)
        get :index, :filter => 'people'
        response.should be_success        
      end
    end
    context "with organizations" do
      it "should return only organizations" do
        Person.should_receive(:find_confirmed_order_by_recency).and_return(mock_person)
        mock_person.should_receive(:only_organizations).and_return(mock_person)
        get :index, :filter => 'organizations'
        response.should be_success        
      end
    end
  end
  describe "ordered_people" do
    context "with newest-member" do
      it "should sort by the most recent newest members who have confirmed" do
        Person.should_receive(:find_confirmed_order_by_recency).and_return(mock_person)
        get :index, :order => 'newest-member'
        response.should be_success
      end
      it "should set the subtitle to 'Newest Members'" do
        get :index, :order => 'newest-member'
        assigns(:subtitle).should == 'Newest Members'
      end
      context "with params[:issue_id]" do
        it "should return the correct record" do
          Issue.stub!(:find).and_return(mock_issue)
          mock_issue.should_receive(:most_newest_users).and_return([mock_person])
          get :index, :issue_id => 1
        end
      end
    end
    context "with alphabetical" do
      it "should sort by alphabet of last name" do
        Person.should_receive(:find_confirmed_order_by_last_name).and_return(mock_person)
        get :index, :order => 'alphabetical'
        response.should be_success
      end
      it "should set the subtitle to 'Alphabetical'" do
        get :index, :order => 'alphabetical'
        assigns(:subtitle).should == 'Alphabetical'
      end
      context "with params[:issue_id]" do
        it "should return the correct record" do
          Issue.stub!(:find).and_return(mock_issue)
          mock_issue.should_receive(:order_by_alpha_users).and_return([mock_person])
          get :index, :issue_id => 1, :order => 'alphabetical'
        end
      end
    end
    context "with most active" do
      it "should sort by the most active users" do
        Person.should_receive(:find_confirmed_order_by_most_active).and_return(mock_person)
        get :index, :order => 'active-member'
        response.should be_success
      end
      it "should set the subtitle to 'Most Active'" do
        get :index, :order => 'active-member'
        assigns(:subtitle).should == 'Most Active'
      end
      context "with params[:issue_id]" do
        it "should return the correct record" do
          Issue.stub!(:find).and_return(mock_issue)
          mock_issue.should_receive(:most_active_users).and_return([mock_person])
          get :index, :issue_id => 1, :order => 'active-member'
        end
      end
    end
    context "default" do
      it "should sort by the most recent newest members who have confirmed" do
        Person.should_receive(:find_confirmed_order_by_recency).and_return(mock_person)
        get :index
        response.should be_success
      end

      it "should set the subtitle to 'Newest Members'" do
        get :index
        assigns(:subtitle).should == 'Newest Members'
      end
    end
  end
end
