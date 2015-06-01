class CreatePrivateLabelsSidebars < ActiveRecord::Migration
  def change
    create_table :private_labels_sidebars do |t|
      t.text :content

      t.timestamps
    end
  end
end
