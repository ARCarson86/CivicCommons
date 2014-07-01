class UpdateNotificationsEmailOption < ActiveRecord::Migration
  def change
  	add_column :notifications, :emailed, :datetime
  	add_column :people, :tag_notification, :boolean, default: true
  end
end
