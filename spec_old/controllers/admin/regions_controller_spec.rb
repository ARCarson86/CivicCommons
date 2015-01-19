require 'spec_helper'

describe Admin::RegionsController do 
  
  def stub_person(attributes={})
    @person ||= stub_model(Person, attributes).as_null_object
  end

  before(:each) do
    @controller.stub(:verify_admin).and_return(true)
    @controller.stub(:current_person).and_return(stub_person(:admin => true))
  end

  describe "GET index" do 
    it "should show all regions" do 
      Region.stub(:all).and_return(:regions)
      get :index
      assigns(:regions).should == :regions
    end
  end

  describe "GET edit" do
  
    before(:each) do
      @region = Region.new
      @region.name = "jake"
      Region.stub(:find).with("1").and_return(@region)
      get :edit, :id=>1
    end

    it "should assign to region" do
      assigns(:region).should == @region
    end

  end

  describe "GET new" do
    it "should assign to region" do
      Region.stub(:new).and_return(:region)
      get :new
      assigns(:region).should == :region
    end
  end

  describe "POST create" do
    context "with valid params" do 
      it "should create counties based on the params" do
        post :create, :region => {:name=>"john", :zip_code_string=>"18621\n11111"}
        assigns(:region).zip_codes.length.should == 2
        assigns(:region).zip_codes.first.to_s.should == "18621"
      end
    end
  end
  
end
