require 'spec_helper'

describe OrganizationsHelper do

  context "organization_membership_button" do
    def mock_person(stubs={})
      @mock_person ||= mock_model(Person, stubs).as_null_object
    end

    def mock_organization(stubs={})
      @mock_organization ||= mock_model(Organization, stubs).as_null_object
    end

    it "should return the correct button if user is a member" do
      organization = mock_organization(:id => 123)
      organization.stub!(:has_member?).and_return(true)
      helper.organization_membership_button(organization, mock_person).should == "<p class=\"membership\"><a href=\"/user/123/remove_membership\" class=\"button remove\" data-method=\"delete\" data-remote=\"true\" rel=\"nofollow\">Leave this organization</a></p>"
    end
    it "should return the correct button if user is not a member" do
      organization = mock_organization(:id => 123)
      organization.stub!(:has_member?).and_return(false)
      helper.organization_membership_button(organization, mock_person).should == "<p class=\"membership\"><a href=\"/user/123/join_as_member\" class=\"button join\">I'm affiliated with this organization</a></p>"
    end
  end
end
