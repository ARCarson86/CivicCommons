require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the CommentsHelper. For example:
# 
# describe CommentsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ContributionsHelper do
  let(:conversation){ stub_model(Conversation).as_null_object}
  let(:contribution){ stub_model(Contribution, { :conversation => conversation} ).as_null_object}
  
  describe "link_to_edit_contribution" do
    it "should return the correct link tag" do
      helper.link_to_edit_contribution(contribution).should == "<a href=\"/conversations/#{conversation.id}/contributions/#{contribution.id}/edit\" class=\"edit-contribution-action\" data-method=\"get\" data-remote=\"true\" data-target=\"#show-contribution-#{contribution.id}\" data-type=\"html\" id=\"edit-#{contribution.id}\">Edit</a>"
    end
    it "should allow for js confirmation" do
      helper.link_to_edit_contribution(contribution, :confirm => 'are you sure?').should == "<a href=\"/conversations/#{conversation.id}/contributions/#{contribution.id}/edit\" class=\"edit-contribution-action\" data-confirm=\"are you sure?\" data-method=\"get\" data-remote=\"true\" data-target=\"#show-contribution-#{contribution.id}\" data-type=\"html\" id=\"edit-#{contribution.id}\">Edit</a>"
    end
  end
end
