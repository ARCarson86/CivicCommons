class DropPrivateLabelAdmins < ActiveRecord::Migration
  def up
    drop_table :private_label_administrators
  end

  def down
  	create_table :private_label_administrators do |t|
  		t.integer :person_id
  		t.integer :private_label_id
  		t.timestamps
  	end
  end
end
