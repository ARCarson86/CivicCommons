module Utilities
  ##
  # Contains methods that are meant to manipulate Conversation
  # records.
  module ConversationUtilities
    ##
    # This method flips through all conversations and looks for any Issues
    # that are associated with them.  If there are, then the Topics from
    # those issues are set for the conversation.
    #
    # No change is made in the relationship between the Conversation and
    # Issue records.  Only Topic relationships are added.
    #
    # In case the Topics for a Conversation have been set already, no 
    # Topic relationships are removed.  Topics are only added based upon
    # any existing relationship between the Conversation and an Issue.
    #
    # @param [Boolean] commit Whether or not to commit changes to the 
    #   database.  Default is +false+, which is essentially a dry run
    #
    # @param [ActiveSupport::BufferedLogger] logger Where to output all
    #   of the status messages. It doesn't have to be a BufferedLogger, but
    #   does need to implement the +info+ method; uses the Rails.logger
    #   by default
    #
    # @param [Array<Conversation>] conversations An optional array of
    #   conversations to process.  If not provided, then all conversations
    #   with relationships to Issues are fetched and processed.
    def self.set_topics_from_issues(commit = false, logger = Rails.logger, conversations = [])
      start = Time.now

      if conversations.empty?
        conversations = Conversation.joins(:issues)
        if conversations.empty?
          logger.info('There are 0 conversations to process.', 'ConversationUtilities')
          return
        end
      end

      logger.info("Processing #{conversations.count} conversations . . . ")

      # Iterate through the conversations
      conversations.each do |conversation|
        logger.info("Processing conversation (#{conversation.id}) - #{conversation.title} . . . ", 'ConversationUtilities')

        # Get a list of the topics that are associated with the conversation
        all_issues = conversation.issues(true)
        all_topics = all_issues.collect { |i| i.topic_ids }
        all_topics.flatten!
        all_topics.uniq!

        if all_topics.empty?
          logger.info("    No topics to add.")
          next
        end

        logger.info("    Topics to be added (ids):  #{all_topics.inspect}")
        all_topics.each do |topic_id|
          topic = Topic.find(topic_id)

          if conversation.topics.include?(topic)
            logger.info("    Conversation already has topic (#{topic.id}) #{topic.name}")
          elsif commit == false
            logger.info("    Topic (#{topic.id}) #{topic.name} would have been added. No changes saved.", 'ConversationUtilities')
          else
            logger.info("    Adding topic (#{topic.id}) #{topic.name}", 'ConversationUtilities')
            conversation.topics << topic unless conversation.topics.include?(topic)
          end
        end
      end

      logger.info(" ---------------------------------------------------")
      logger.info("Finish processing #{conversations.count} conversations in #{Time.now - start} seconds")
    end
  end
end
