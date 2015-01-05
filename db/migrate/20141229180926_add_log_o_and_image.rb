class AddLogOAndImage < ActiveRecord::Migration
  def change
  	add_attachment :private_labels, :logo
  	add_attachment :private_labels, :main_image
  end
end
