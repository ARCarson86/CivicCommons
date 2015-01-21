class AddAdminToPrivateLabelPeople < ActiveRecord::Migration
  def change
    add_column :private_label_people, :admin, :boolean, default: false
  end
end
