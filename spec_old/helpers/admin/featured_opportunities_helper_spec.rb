require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the Admin::FeaturedOpportunitiesHelper. For example:
#
# describe Admin::FeaturedOpportunitiesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe Admin::FeaturedOpportunitiesHelper do
  def mock_contribution(stubs={})
    @mock_contribution ||= mock_model(Contribution, stubs).as_null_object
  end
    
  describe "strip_and_truncate" do
    it "strips the text correctly" do
      helper.strip_and_truncate("<p>hello</p>").should == "hello"
    end
    it "truncates correctly" do
      helper.strip_and_truncate('hello world this is a long sentence', 10).should == "hello w..."
    end
  end
  describe "featured_opportunity_options_for_select" do
    before(:each) do
      helper.stub(:strip_and_truncate).and_return('Option Here')
    end
    it "should return blank if there is no record" do
      helper.featured_opportunity_options_for_select(nil,nil).should == ''
    end
    context "if there is a record" do
      it "should have 'select one...' option" do
        helper.featured_opportunity_options_for_select([mock_contribution(:id => 123)],nil).should == "<option value=\"\">Select one...</option>\n<option value=\"123\">Option Here</option>"
      end
      it "should use strip_and_truncate method" do
        helper.should_receive(:strip_and_truncate)
        helper.featured_opportunity_options_for_select([mock_contribution(:id => 123)],nil)
      end
    end
  end
end