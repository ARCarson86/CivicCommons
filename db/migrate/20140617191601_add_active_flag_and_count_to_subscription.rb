class AddActiveFlagAndCountToSubscription < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :inactive, :boolean
  	add_column :subscriptions, :notification_count, :integer
  	add_column :people, :subscriptions_setting, :string, :default => "daily"
  end
end
