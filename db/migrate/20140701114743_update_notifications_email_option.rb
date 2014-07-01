class UpdateNotificationsEmailOption < ActiveRecord::Migration
  def change
  	add_column :notifications, :emailed_at, :datetime
  	add_column :notifications, :emailed, :boolean
  end
end
