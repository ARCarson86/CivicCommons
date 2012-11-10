class CreateConversationsTopics < ActiveRecord::Migration
  def change
    create_table :conversations_topics do |t|
      t.references :conversation
      t.references :topic
      t.timestamps
    end

    add_index :conversations_topics, :conversation_id
    add_index :conversations_topics, :topic_id
    add_index :conversations_topics, [:conversation_id, :topic_id], :unique => true
  end
end
