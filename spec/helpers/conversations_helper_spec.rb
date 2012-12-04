require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ConversationsHelper. For example:
# 
# describe ConversationsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ConversationsHelper do
  def mock_content_item(attributes={})
    @content_item ||= mock_model(ContentItem, attributes).as_null_object
  end
  
  describe "path_to_content_item" do
    it "should return radioshow path on radioshow content item" do
      helper.path_to_content_item(mock_content_item(:content_type => 'RadioShow',:id => 123)).should == radioshow_path(mock_content_item)
    end
    it "should return blog post path on blog post item" do
      helper.path_to_content_item(mock_content_item(:content_type => 'BlogPost',:id => 123)).should == blog_path(mock_content_item)
    end
  end
  
  describe "short_title" do
    let(:long_title) { 'This is a very long title that is more than fifty characters long and should be truncated' }
    let(:shorter_title) { 'This is short' }

    context 'when text is too long' do
      subject { helper.short_title(long_title) }

      it "should return a text shorter than 50 character if it's more" do
        subject.length.should <= 50
      end

      it 'should return a string ending with ellipsis' do
        subject.end_with?('...').should be_true
      end

      context 'when a different length is passed in' do
        it 'should truncate to the number passed in' do
          helper.short_title(long_title, 30).length.should <= 30
        end
      end
    end

    context 'when text is short' do
      it "should return the same text if it's less than 50 characacter" do
        helper.short_title(shorter_title).should == shorter_title
      end
    end
  end
  
  describe "get_path_sym" do
    it "should return :radioshow on radioshow" do
      helper.get_path_sym(mock_content_item(:content_type => 'RadioShow',:id => 123)).should == :radioshow
    end
    it "should return :blog on blogpost" do
      helper.get_path_sym(mock_content_item(:content_type => 'BlogPost',:id => 123)).should == :blog
    end
  end

  describe 'opportunity_navigation_item_selected?' do
    it 'should return true if the controller is the same as type argument' do
      controller.stub!(:controller_name).and_return('conversations')
      helper.opportunity_navigation_item_selected?('conversations').should be_true
    end

    it 'should return false if the controller is different than the type argument' do
      controller.stub!(:controller_name).and_return('actions')
      helper.opportunity_navigation_item_selected?('conversations').should be_false
    end
  end
end
