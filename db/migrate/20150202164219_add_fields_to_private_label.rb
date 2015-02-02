class AddFieldsToPrivateLabel < ActiveRecord::Migration
  def change
    add_column :private_labels, :title, :string
    add_column :private_labels, :tagline, :string
  end
end
