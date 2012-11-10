class ConversationsTopic < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :topic

  validates :topic_id, :uniqueness => { :scope => :conversation_id }
end
