require 'spec_helper'

module Utilities
  describe ConversationUtilities do
    before(:each) do
      @issue1 = FactoryGirl.create(:issue_with_conversation)
      @issue2 = FactoryGirl.create(:issue_with_conversation)
    end

    describe 'commit argument' do
      it 'is false by default' do
        subject.set_topics_from_issues

        conversation = @issue1.conversations.first
        @issue1.topics.each do |topic|
          conversation.topics.should_not include(topic)
        end
      end

      context 'when commit is true' do
        it 'saves the changes to the database' do
          subject.set_topics_from_issues(true)

          conversation = @issue1.conversations.first
          @issue1.topics.each do |topic|
            conversation.topics(true).should include(topic)
          end
        end
      end
    end

    describe 'conversations argument' do
      context 'when provided with an array of conversations' do
        it 'only processes those conversations' do
          conversation1 = @issue1.conversations.first
          conversation2 = @issue2.conversations.first

          subject.set_topics_from_issues(true, Logger::DEBUG, [conversation1])

          @issue1.topics(true).each do |topic|
            conversation1.topics(true).should include(topic)
          end

          @issue2.topics(true).each do |topic|
            conversation2.topics(true).should_not include(topic)
          end
        end
      end

      context 'when not provided with an array of conversations' do
        it 'processes all conversations with issues' do
          subject.set_topics_from_issues(true)

          @issue1.conversations(true).each do |conversation|
            @issue1.topics(true).each do |topic|
              conversation.topics(true).should include(topic)
            end
          end

          @issue2.conversations(true).each do |conversation|
            @issue2.topics(true).each do |topic|
              conversation.topics(true).should include(topic)
            end
          end
        end
      end
    end

    context 'when a conversation has a different topic already' do
      it 'does not remove the topic from the conversation' do
        conversation = @issue1.conversations.first
        odd_topic = FactoryGirl.create(:topic)
        conversation.topics << odd_topic

        subject.set_topics_from_issues(true, Rails.logger, [conversation])

        @issue1.topics(true).each do |topic|
          conversation.topics(true).should include(topic)
        end

        conversation.topics(true).should include(odd_topic)
      end
    end
  end

end
