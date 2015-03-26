class AddConversationIdToRemotePages < ActiveRecord::Migration
  def change
    add_column :remote_pages, :conversation_id, :integer
  end
end
