class AddStarterToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :starter, :text
  end
end
