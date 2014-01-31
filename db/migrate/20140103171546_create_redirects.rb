class CreateRedirects < ActiveRecord::Migration
  def change
    create_table :redirects do |t|
      t.string :path
      t.string :destination

      t.timestamps
    end
  end
end
