# passing
require 'spec_helper'

describe ContentItemLink do
  describe "associations" do
    it "should have belongs_to :content_item" do
      ContentItemLink.reflect_on_association(:content_item).macro.should == :belongs_to
    end
  end
  describe "validations" do
    before(:each) do
      @content_item_link = FactoryGirl.build(:content_item_link)
    end

    it "validates presence of title" do
      @content_item_link.title = nil
      @content_item_link.should_not be_valid
    end

    it "validates presence of url" do
      @content_item_link.url = nil
      @content_item_link.should_not be_valid
    end
    
    describe "validates format of url" do
      it "should allow to save correctly formatted url" do
        @content_item_link.url = 'http://example.com'
        @content_item_link.should be_valid
      end
      it "should not allow to save incorrectly formatted url" do
        @content_item_link.url = 'wrong-url-format-here'
        @content_item_link.should_not be_valid
        @content_item_link.errors[:url].include?("must look like a url(example http://google.com)").should be_true
      end
    end
  end
end
