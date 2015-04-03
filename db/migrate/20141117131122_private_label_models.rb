class PrivateLabelModels < ActiveRecord::Migration
  def change
  	create_table :private_labels do |t|
  		t.string :name
  		t.string :namespace
  		t.string :domain
      t.text   :terms_of_service
  		t.timestamps
  	end
  	create_table :private_label_administrators do |t|
  		t.integer :person_id
  		t.integer :private_label_id
  		t.timestamps
  	end
    create_table :private_label_people do |t|
      t.integer :private_label_id
      t.integer :person_id
      t.timestamps
    end
  	add_column :conversations, :private_label_id, :integer
  	add_column :contributions, :private_label_id, :integer
  end
end
