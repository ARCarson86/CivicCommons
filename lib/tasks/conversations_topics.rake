namespace :conversations_topics do

  desc 'Update topics on conversations to match the topics on their associated issues; use COMMIT=TRUE to save changes'
  task :update_from_issues => :environment do

    logger = ActiveSupport::BufferedLogger.new(STDOUT)

    commit = ENV['COMMIT'] == 'TRUE' ? true : false

    Utilities::ConversationUtilities.set_topics_from_issues(commit, logger)
  end
end
