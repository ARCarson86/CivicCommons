class AddPrivateLabelToPrivateLabelPage < ActiveRecord::Migration
  def change
    add_column :private_labels_pages, :private_label_id, :integer
  end
end
