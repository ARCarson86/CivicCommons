class CreatePrivateLabelsPages < ActiveRecord::Migration
  def change
    create_table :private_labels_pages do |t|
      t.string :title
      t.string :slug
      t.text :content
      t.boolean :sidebar
      t.string :meta_title
      t.string :meta_keywords
      t.string :meta_description

      t.timestamps
    end
    add_index :private_labels_pages, :slug, unique: true
  end
end
