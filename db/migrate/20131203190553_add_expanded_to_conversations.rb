class AddExpandedToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :expanded, :boolean
  end
end
