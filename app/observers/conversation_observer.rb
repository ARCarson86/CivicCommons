class ConversationObserver < ActiveRecord::Observer


  def after_save(conversation)
  end

  def after_create(conversation)
    conversation.set_initial_position
    conversation.subscribe_creator

    if conversation.other_topic
      Notifier.other_conversation_topic_selected(self).deliver if conversation.other_topic
    end
  end

end
