require 'spec_helper'

module Admin
  describe ManagedIssuePagesController do

    before(:each) do
      sign_in FactoryGirl.create(:admin_person)
    end

    let(:issue) do
      FactoryGirl.create(:managed_issue)
    end

    describe "GET all" do

      before(:each) do
        @managed_issue_pages = {}
        (1..5).each do 
          page = FactoryGirl.create(:managed_issue_page, issue: issue)
          @managed_issue_pages[page.id] = page
        end
      end

      it "assigns all managed_issue_pages as @managed_issue_pages" do
        get :index, :issue_id => issue.id
        assigns[:managed_issue_pages].size.should == @managed_issue_pages.size
      end
    end

    describe "GET index" do

      before(:each) do
        @managed_issue_pages = {}
        (1..5).each do 
          page = FactoryGirl.create(:managed_issue_page, issue: issue)
          @managed_issue_pages[page.id] = page
        end
      end

      it "assigns all managed_issue_pages as @managed_issue_pages" do
        get :index, :issue_id => issue.id
        assigns[:managed_issue_pages].size.should == @managed_issue_pages.size
      end

    end

    describe "GET show" do

      let(:page) do
        FactoryGirl.create(:managed_issue_page)
      end

      it "assigns the requested managed_issue_page as @managed_issue_page" do
        get :show, :issue_id => issue.id, :id => page.id.to_s
        assigns[:managed_issue_page].should eq page
      end

    end

    describe "GET new" do

      it "assigns a new managed_issue_page as @managed_issue_page" do
        get :new, :issue_id => issue.id
        assigns[:managed_issue_page].should_not be_nil
      end

    end

    describe "GET edit" do

      let(:page) do
        FactoryGirl.create(:managed_issue_page)
      end

      it "assigns the requested managed_issue_page as @managed_issue_page" do
        get :edit, :issue_id => issue.id, :id => page.id.to_s
        assigns[:managed_issue_page].should eq page
      end

    end

    describe "POST create" do

      describe "with valid params" do

        let(:params) do
          FactoryGirl.attributes_for(:managed_issue_page)
        end

        before(:each) do
          post :create, :issue_id => issue.id, :managed_issue_page => params
        end

        it "assigns a newly created managed_issue_page as @managed_issue_page" do
          assigns[:managed_issue_page].name.should eq params[:name]
          assigns[:managed_issue_page].template.should eq params[:template]
        end

        it "redirects to the created managed_issue_page" do
          response.should redirect_to admin_issue_page_path(issue, assigns[:managed_issue_page])
        end

      end

      describe "with invalid params" do

        let(:params) do
          FactoryGirl.attributes_for(:managed_issue_page)
        end

        before(:each) do
          params.delete(:name)
          post :create, :issue_id => issue.id, :managed_issue_page => params
        end

        it "assigns a newly created but unsaved managed_issue_page as @managed_issue_page" do
          assigns[:managed_issue_page].template.should eq params[:template]
        end

        it "re-renders the 'new' template" do
          response.should render_template('new')
        end

      end

    end

    describe "PUT update" do

      let(:page) do
        FactoryGirl.create(:managed_issue_page)
      end

      let(:new_name) do
        "Some completely different but valid name"
      end

      let(:params) do
        page.attributes
      end

      describe "with valid params" do

        before(:each) do
          params['name'] = new_name
          put :update, :issue_id => issue.id, :id => params['id'], :managed_issue_page => params
        end

        it "updates the requested managed_issue_page" do
          ManagedIssuePage.find_by_id(params['id']).name.should eq new_name
        end

        it "assigns the requested managed_issue_page as @managed_issue_page" do
          assigns[:managed_issue_page].id.should eq params['id']
          assigns[:managed_issue_page].name.should eq new_name
          assigns[:managed_issue_page].template.should eq params['template']
        end

        it "redirects to the 'GET show' page" do
          response.should redirect_to admin_issue_page_path(issue, page)
        end

      end

      describe "with invalid params" do

        before(:each) do
          params['name'] = ''
          put :update, :issue_id => issue.id, :id => params['id'], :managed_issue_page => params
        end

        it "assigns the managed_issue_page as @managed_issue_page" do
          assigns[:managed_issue_page].id.should eq params['id']
          assigns[:managed_issue_page].name.should eq params['name']
          assigns[:managed_issue_page].template.should eq params['template']
        end

        it "re-renders the 'edit' template" do
          response.should render_template('edit')
        end

      end

    end

    describe "DELETE destroy" do

      let(:page) do
        FactoryGirl.create(:managed_issue_page)
      end

      before(:each) do
        delete :destroy, :issue_id => issue.id, :id => page.id
      end

      it "destroys the requested managed_issue_page" do
        ManagedIssuePage.find_by_id(page.id).should be_nil
      end

      it "redirects to the managed_issue_pages list" do
        response.should redirect_to(admin_issue_pages_path(issue))
      end

    end

  end
end
