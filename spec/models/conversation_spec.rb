require 'spec_helper'

describe Conversation do
  describe "when retrieving all of the issues associated with a conversation" do
    before(:each) do
      @normal_person = Factory.create(:normal_person)      
    end
    it "should return issue" do
      conversation = Factory.create(:conversation)
      issue = Factory.create(:issue, :conversations=>[conversation])
      
      conversation.issues.count.should == 1      
      conversation.issues[0].should == issue
    end
  end

  describe "when creating a post for the conversation" do
    before(:each) do
      @comment = Factory.create(:comment)
      @person = Factory.create(:normal_person)
      @conversation = Factory.create(:conversation)
    end

  end  
  context "about an issue" do
    
    it "should sort by the latest updated conversations" do
      @issue = Factory.create(:issue, :description => 'A first issue')
      @conversation1 = Factory.create(:conversation, :issues => [@issue])
      @conversation2 = Factory.create(:conversation, :issues => [@issue])
      @conversation3 = Factory.create(:conversation, :issues => [@issue])
      @conversation4 = Factory.create(:conversation)
      @conversation2.touch
      @issue.conversations.latest_updated.should == [@conversation2,@conversation3,@conversation1]
    end
  end
  
end