class AdditionalColsOnNotificationsTab < ActiveRecord::Migration
  def up
    add_column :notifications, :item_created_at, :datetime
    add_column :notifications, :conversation_id, :integer
    add_column :notifications, :issue_id, :integer
    add_column :notifications, :receiver_id, :integer
    add_column :notifications, :notification_type, :string
    add_index :notifications, :item_created_at
    add_index :notifications, :conversation_id
    add_index :notifications, :issue_id
    add_index :notifications, :item_id
    add_index :notifications, :item_type
    add_index :notifications, :receiver_id
  end

  def down
    remove_index :notifications, :receiver_id
    remove_index :notifications, :item_id
    remove_index :notifications, :item_type
    remove_index :notifications, :item_created_at
    remove_index :notifications, :conversation_id
    remove_index :notifications, :issue_id
    remove_column :notifications, :notification_type
    remove_column :notifications, :receiver_id
    remove_column :notifications, :item_created_at
    remove_column :notifications, :conversation_id
    remove_column :notifications, :issue_id
  end
end