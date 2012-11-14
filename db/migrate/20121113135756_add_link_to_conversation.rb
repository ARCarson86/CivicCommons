class AddLinkToConversation < ActiveRecord::Migration
  def self.up
    add_column :conversations, :link, :string
  end

  def self.down
    remove_column :conversations, :link
  end
end
