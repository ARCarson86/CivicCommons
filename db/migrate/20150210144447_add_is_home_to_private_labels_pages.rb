class AddIsHomeToPrivateLabelsPages < ActiveRecord::Migration
  def change
    add_column :private_labels_pages, :is_home, :boolean
  end
end
