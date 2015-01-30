require 'spec_helper'

describe PagesController do

  context "GET show" do

    it "assigns the requested ContentTemplate as @template" do
      template = FactoryGirl.create(:content_template)
      get :show, :id => template.id
      assigns[:template].should == template
    end

    it "redirects to the home page when the requested ContentTemplate is not found" do
      get :show, :id => 'does-not-exist'
      response.should redirect_to root_path
    end

  end

end
