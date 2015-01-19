require 'spec_helper'

describe ManagedIssuePagesController do

  context "GET show" do

    it "assigns the requested managed issue page as @" do
      page = FactoryGirl.create(:managed_issue_page)
      get :show, :issue_id => page.issue.id, :id => page.id
      assigns[:page].should == page
    end

    it "redirects to the issue page when the requested managed issue page is not found" do
      issue = FactoryGirl.create(:managed_issue)
      get :show, :issue_id => issue.id, :id => 'does-not-exist'
      response.should redirect_to issue_path(issue)
    end

    it "redirects to the issue index page when the requested issue is a standard issue" do
      issue = FactoryGirl.create(:issue)
      get :show, :issue_id => issue.id, :id => 'does-not-exist'
      response.should redirect_to issues_path
    end

    it "redirects to the issue index page when the requested issue is not found" do
      get :show, :issue_id => 'does-not-exist', :id => 'does-not-exist'
      response.should redirect_to issues_path
    end

  end

end
