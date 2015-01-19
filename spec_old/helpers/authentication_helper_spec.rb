require 'spec_helper'

describe AuthenticationHelper do
  # error when invoking this path, so faking it here.
  def person_omniauth_authorize_path(options ={})
    '/path/here' 
  end
  
  context "unlink_from_facebook_link" do
    it "should return the link" do
      unlink_from_facebook_link.should have_selector 'a.connectacct-link.facebook-auth.disconnect-fb', :href => confirm_facebook_unlinking_path
    end
  end
  
  context "link_with_facebook_link" do
    it "should return the correct link" do
      link_with_facebook_link.should have_selector 'a.connectacct-link.facebook-auth', :href => "/path/here"
    end
  end
  
  context "facebook_sign_in_link" do
    it "should return the correct link" do
      facebook_sign_in_link.should have_selector 'a.createacct-link.facebook-auth.fb-login-btn', :href => "/path/here"
    end
  end
  
  context "person_omniauth_authorize_path_or_url" do
    it "should return the url if https" do
      SecureUrlHelper.stub(:https?).and_return(true)
      person_omniauth_authorize_path_or_url(:facebook).should == 'https://test.host/people/auth/facebook'
    end
    it "should return the path if not https" do
      SecureUrlHelper.stub(:https?).and_return(false)
      person_omniauth_authorize_path_or_url(:facebook).should == '/path/here'
    end
  end
end
