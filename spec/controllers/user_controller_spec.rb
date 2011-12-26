require 'spec_helper'

describe UserController do
  def stub_person(stubs={})
    stub_model(Person, stubs)
  end
  def stub_organization(stubs ={})
    stub_model(Organization,stubs).as_null_object
  end
  
  context "POST destroy_avatar" do
    
    def given_user_with_facebook_authenticated_and_without_avatar
      @person = stub_person(:facebook_authenticated? => true, :avatar => false, :facebook_profile_pic_url => 'graph.facebook.com/1234/picture')
    end
    
    def given_user_without_facebook_authenticated
      @person = stub_person(:facebook_authenticated? => false)
    end
    
    before(:each) do
      controller.stub(:verify_ownership?).and_return(true)
    end

    it "should return the avatar if have not been authenticated with Facebook " do
      given_user_without_facebook_authenticated
      Person.stub(:find).and_return(@person)
      @person.stub(:save).and_return(true)
      
      delete :destroy_avatar, :id => "1234", :format => :js
      response.should contain "{\"avatarUrl\":\"/images/avatar_70.gif\"}"
    end

    it "should return the Facebook url if account has already authenticated with Facebook" do
      given_user_with_facebook_authenticated_and_without_avatar
      Person.stub(:find).and_return(@person)
      @person.stub(:save).and_return(true)
      
      delete :destroy_avatar, :id => "1234", :format => :js
      response.should contain "{\"avatarUrl\":\"graph.facebook.com/1234/picture\"}"
    end
    
    it "should return 500 if unable to save" do
      @person = stub_person
      Person.stub(:find).and_return(@person)
      @person.stub(:save).and_return(false)
      
      delete :destroy_avatar, :id => '1234', :format => :js
      response.status.should == 500
    end
  end
  
  context "POST join_as_member" do
    before(:each) do
      @person = stub_person
      controller.stub!(:current_person).and_return(@person)
      @organization = stub_organization
      Organization.stub!(:find).and_return(@organization)
    end
    it "should add the user to the organization's members" do
      @organization.should_receive(:join_as_member).with(@person)
      post :join_as_member, :id => '1234'
    end
    it "should render template membership_button " do
      @organization.stub!(:join_as_member).and_return(true)
      post :join_as_member, :id => '1234', :format => 'js'
      response.should render_template '/organizations/_membership_button'
    end
  end
  
  context "DELETE remove_membership" do
    before(:each) do
      @person = stub_person
      controller.stub!(:current_person).and_return(@person)
      @organization = stub_organization
      Organization.stub!(:find).and_return(@organization)
    end
    it "should remove the user from the organization's members" do
      @organization.should_receive(:remove_member).with(@person).and_return(true)
      delete :remove_membership, :id => '1234'
    end
    it "should render template membership_button" do
      @organization.stub!(:remove_member).and_return(true)
      delete :remove_membership, :id => '1234', :format => 'js'
      response.should render_template '/organizations/_membership_button'
    end
  end
end
