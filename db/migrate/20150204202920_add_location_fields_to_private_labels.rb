class AddLocationFieldsToPrivateLabels < ActiveRecord::Migration
  def change
  	add_column :private_labels, :latitude, :float
  	add_column :private_labels, :longitude, :float
  end
end
