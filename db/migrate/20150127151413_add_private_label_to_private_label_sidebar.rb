class AddPrivateLabelToPrivateLabelSidebar < ActiveRecord::Migration
  def change
    add_column :private_labels_sidebars, :private_label_id, :integer
  end
end
