class CreatePersonSubscriptionSettings < ActiveRecord::Migration
  def change
  	create_table :personal_settings, :force => true do |t|
      t.integer :person_id
      t.boolean :tag_notification
      t.string :notification_frequency, :default => "daily"
      t.timestamps
    end
  end
end
