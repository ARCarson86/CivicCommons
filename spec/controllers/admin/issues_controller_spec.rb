require 'spec_helper'

module Admin
  describe IssuesController do
    let(:topic) { FactoryGirl.create(:topic) }
    before(:each) do
      sign_in FactoryGirl.create(:admin_person)
        FactoryGirl.create(:topic)
    end

    describe "GET index" do

      before(:each) do
        @issues = {}
        (1..5).each do 
          issue = FactoryGirl.create(:managed_issue)
          @issues[issue.id] = issue
        end
      end

      it "assigns all issues as @issues" do
        get :index
        assigns[:issues].size.should == @issues.size
      end

    end

    describe "GET show" do

      let(:issue) do
        FactoryGirl.create(:managed_issue)
      end

      it "assigns the requested issue as @issue" do
        get :show, :id => issue.id.to_s
        assigns[:issue].should eq issue
      end

      it "assigns the requested issue as @issue" do
        get :show, :id => issue.id.to_s
      end

    end

    describe "GET new" do

      before do
        get :new
      end
      it "assigns a new issue as @issue" do
        assigns[:issue].should_not be_nil
      end

      it 'gives all the topics to view' do
        assigns[:topics].should == Topic.all
      end

    end

    describe "GET edit" do
      let(:unselected_topic) { FactoryGirl.create(:topic)}
      before(:each) do
        @issue = FactoryGirl.create(:managed_issue, topics: [topic])
        get :edit, :id => issue.id.to_s
      end

      let(:issue) do
        @issue
      end

      it "assigns the requested issue as @issue" do
        assigns[:issue].should eq issue
      end

      it 'gives all the topics to view' do
        assigns[:topics].should == Topic.all
      end

      it 'shows issue topics as checked' do
        assigns[:issue].topics.should include topic
        assigns[:issue].topics.should_not include unselected_topic 
      end

    end

    describe "POST create" do

      describe "with valid params" do

        before(:each) do
          @params = FactoryGirl.build(:managed_issue).attributes.symbolize_keys
          @params[:topic_ids] = [topic.id]
          post :create, :issue => @params
        end

        it "assigns a newly created issue as @issue" do
          assigns[:issue].name.should eq @params[:name]
          assigns[:issue].summary.should eq @params[:summary]
          assigns[:issue].sponsor_name.should eq @params[:sponsor_name]
        end

        it "redirects to the issues index" do
          response.should redirect_to admin_issues_path
        end

      end

      describe "with invalid params" do

        let(:params) do
          FactoryGirl.build(:managed_issue).attributes.symbolize_keys
        end

        before(:each) do
          params.delete(:name)
          params[:topic_ids] = [topic.id]
          post :create, :issue => params
        end

        it "assigns a newly created but unsaved issue as @issue" do
          assigns[:issue].summary.should eq params[:summary]
        end

        it "re-renders the 'new' issue" do
          response.should render_template('new')
        end
        it "provides the topics" do
          assigns[:topics].should == Topic.all
        end
      end

      describe "with subclasses" do

        it "creates issues" do
          params = FactoryGirl.build(:managed_issue).attributes.symbolize_keys
          params[:type] = 'ManagedIssue'
          params[:topic_ids] = [topic.id]
          post :create, :issue => params
          assigns[:issue].should be_a ManagedIssue
          assigns[:issue].type.should == "ManagedIssue"
        end

        it "creates managed issues" do
          params = FactoryGirl.build(:managed_issue).attributes.symbolize_keys
          params[:type] = 'ManagedIssue'
          params[:topic_ids] = [topic.id]
          post :create, :issue => params
          assigns[:issue].type.should == "ManagedIssue"
        end

      end

    end

    describe "PUT update" do

      let(:issue) do
        FactoryGirl.create(:managed_issue)
      end

      let(:new_name) do
        "Some completely different but valid name"
      end

      let(:params) do
        issue.attributes
      end

      describe "with valid params" do

        before(:each) do
          params['name'] = new_name
          params[:topic_ids] = issue.topics.collect(&:id)
          put :update, :id => params['id'], :issue => params
        end

        it "updates the requested issue" do
          ManagedIssue.find_by_id(params['id']).name.should eq new_name
        end

        it "assigns the requested issue as @issue" do
          assigns[:issue].id.should eq params['id']
          assigns[:issue].name.should eq new_name
          assigns[:issue].summary.should eq params['summary']
          assigns[:issue].sponsor_name.should eq params['sponsor_name']
        end

        it "redirects to the issues index" do
          response.should redirect_to admin_issues_path
        end

      end

      describe "with invalid params" do

        before(:each) do
          params['name'] = ''
          params[:topic_ids] = issue.topics.collect(&:id)
          put :update, :id => params['id'], :issue => params
        end

        it "assigns the issue as @issue" do
          assigns[:issue].id.should eq params['id']
          assigns[:issue].name.should eq params['name']
          assigns[:issue].summary.should eq params['summary']
          assigns[:issue].sponsor_name.should eq params['sponsor_name']
        end

        it 'provides the topics' do
          assigns[:topics].should == Topic.all
        end

        it "re-renders the 'edit' issue" do
          response.should render_template('edit')
        end

      end
    end

    describe "PUT update_order" do
      it "returns an error response if current_position is blank" do
        put :update_order, :current => ''
        response.should_not be_success
      end

      it "returns an error response if current_position is not blank, but next and previous are" do
        FactoryGirl.create(:managed_issue, :position => 0)
        put :update_order, :current => '0', :next => '', :prev => ''
        response.should_not be_success
      end

      it "returns a success response if current_position is not blank, and next_position or prev_position or both" do
        FactoryGirl.create(:managed_issue, :position => 0)
        FactoryGirl.create(:managed_issue, :position => 1)
        FactoryGirl.create(:managed_issue, :position => 2)
        put :update_order, :current => '0', :next => '1'
        response.should be_success
        put :update_order, :current => '0', :prev => '1'
        response.should be_success
        put :update_order, :current => '0', :next => '1', :prev => '2'
        response.should be_success
      end

      it "returns an error response if current_position does not exist for an issue" do
        put :update_order, :current => '0'
        response.should_not be_success
      end

      it "returns an error response if next_position does not exist for an issue and previous is not set" do
        FactoryGirl.create(:managed_issue, :position => 0)
        put :update_order, :current => '0', :next => '1'
        response.should_not be_success
      end

      it "returns an error response if previous_position does not exist for an issue and next is not set" do
        FactoryGirl.create(:managed_issue, :position => 0)
        put :update_order, :current => '0', :prev => '1'
        response.should_not be_success
      end
    end

    describe "DELETE destroy" do

      let(:issue) do
        FactoryGirl.create(:managed_issue)
      end

      before(:each) do
        delete :destroy, :id => issue.id
      end

      it "destroys the requested issue" do
        ManagedIssue.find_by_id(issue.id).should be_nil
      end

      it "redirects to the issues list" do
        response.should redirect_to(admin_issues_path)
      end

    end

  end
end
