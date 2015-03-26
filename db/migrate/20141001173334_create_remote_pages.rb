class CreateRemotePages < ActiveRecord::Migration
  def change
    create_table :remote_pages do |t|
      t.text :url
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
