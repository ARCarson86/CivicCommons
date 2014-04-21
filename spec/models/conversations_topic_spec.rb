#passed
require 'spec_helper'

describe ConversationsTopic do
  let(:conversation) { FactoryGirl.create(:conversation) }
  let(:topic) { FactoryGirl.create(:topic) }

  context "Associations" do
    it { should belong_to :conversation }
    it { should belong_to :topic }
  end

  context "Validations" do
    before(:each) do
      ConversationsTopic.create(:conversation => conversation, :topic => topic)
    end
    subject { ConversationsTopic.new(:conversation => conversation, :topic => topic) }

    it "requires unique conversation and topic" do
      subject.should validate_uniqueness_of(:topic_id).scoped_to(:conversation_id)
    end

    it "allows multiple topics for the same conversation" do
      conversation_other = FactoryGirl.create(:conversation)
      
      conversation_topic = ConversationsTopic.new(:conversation => conversation_other, :topic => topic)
      conversation_topic.should be_valid
    end

    it "allows the same topic to have multiple conversations" do
      topic_other = FactoryGirl.create(:topic)

      conversation_topic = ConversationsTopic.new(:conversation => conversation, :topic => topic_other)
      conversation_topic.should be_valid
    end
  end
end
