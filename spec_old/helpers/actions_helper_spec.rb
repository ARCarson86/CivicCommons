require 'spec_helper'

describe ActionsHelper do
  def mock_petition(attributes={})
    @petition ||= mock_model(Petition, attributes).as_null_object
  end
  
  describe 'moderate_link_for' do
    it "should correctly show the moderate links on petition" do
      @petition = mock_petition(:id => '1234')
      moderate_link_for(@petition).should == "<p class=\"fl-right alert alert-admin\">&nbsp;<strong>Moderate:</strong> <a href=\"http://test.host/conversations/1234/petitions/1234/edit\">Edit</a> | <a href=\"http://test.host/conversations/1234/petitions/1234\" data-confirm=\"Are you sure you want to delete this?\" data-method=\"delete\" rel=\"nofollow\">Delete</a></p>"
    end
  end
end