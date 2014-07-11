class ChangeDefaultOfSubSettings < ActiveRecord::Migration
  def change
  	change_column :people, :subscriptions_setting, :string, :default => "hourly"
  end
end
