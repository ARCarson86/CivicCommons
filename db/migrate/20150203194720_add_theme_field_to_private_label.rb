class AddThemeFieldToPrivateLabel < ActiveRecord::Migration
  def change
    add_column :private_labels, :theme, :string
  end
end
