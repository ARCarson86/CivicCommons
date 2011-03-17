require 'spec_helper'

describe SecureUrlHelper do

  def turn_ssl_on
    Civiccommons::Config.security['ssl_login'] = true
  end

  def turn_ssl_off
    Civiccommons::Config.security['ssl_login'] = false
  end

  before(:all) do
    @ssl_login = Civiccommons::Config.security['ssl_login']
  end

  after(:all) do
    Civiccommons::Config.security['ssl_login'] = @ssl_login
  end

  describe "secure_registration_form_url" do

    it "should return the correct URL when SSL is enabled" do
      turn_ssl_on
      secure_registration_form_url.should == "https://test.host/people/register/new"
    end

    it "should return the correct URL when SSL is disabled" do
      turn_ssl_off
      secure_registration_form_url.should == "http://test.host/people/register/new"
    end

  end

  # Doesn't work because the Devise registration_url helper isn't available
  #describe "secure_registration_url" do
    
    #before(:all) do
      #@resource = Person.new
    #end

    #it "should return the correct URL when SSL is enabled" do
      #turn_ssl_on
      #secure_registration_url(@resource).should == "https://test.host/people/register/new"
    #end

    #it "should return the correct URL when SSL is disabled" do
      #turn_ssl_off
      #secure_registration_url(@resource).should == "http://test.host/people/register/new"
    #end

  #end

  describe "secure_edit_user_url" do

    before(:all) do
      @resource = Factory.build(:registered_user, :id => 1)
    end

    it "should return the correct URL when SSL is enabled" do
      turn_ssl_on
      secure_edit_user_url(@resource).should == "https://test.host/user/1/edit"
    end

    it "should return the correct URL when SSL is disabled" do
      turn_ssl_off
      secure_edit_user_url(@resource).should == "http://test.host/user/1/edit"
    end

  end

  describe "secure_user_url" do

    before(:all) do
      @resource = Factory.build(:registered_user, :id => 1)
    end

    it "should return the correct URL when SSL is enabled" do
      turn_ssl_on
      secure_user_url(@resource).should == "https://test.host/user/1"
    end

    it "should return the correct URL when SSL is disabled" do
      turn_ssl_off
      secure_user_url(@resource).should == "http://test.host/user/1"
    end

  end

  describe "secure_session_url" do

    before(:all) do
      @resource = Contribution.new
    end

    it "should return the correct URL when SSL is enabled and no resource is supplied" do
      turn_ssl_on
      secure_session_url.should == "https://test.host/people/login"
    end

    it "should return the correct URL when SSL is disabled and no resource is supplied" do
      turn_ssl_off
      secure_session_url.should == "http://test.host/people/login"
    end

    it "should return the correct URL when SSL is enabled and a valid resource is supplied" do
      turn_ssl_on
      secure_session_url(@resource).should == "https://test.host/people/login?format="
    end

    it "should return the correct URL when SSL is disabled and a valid resource is supplied" do
      turn_ssl_off
      secure_session_url(@resource).should == "http://test.host/people/login?format="
    end

  end

end
