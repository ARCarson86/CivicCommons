class PermissionToUseImageOnConvo < ActiveRecord::Migration
  def up
    add_column :conversations, :permission_to_use_image, :boolean
  end

  def down
    remove_column :conversations, :permission_to_use_image
  end
end