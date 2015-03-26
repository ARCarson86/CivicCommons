class AddParentIndexToContributions < ActiveRecord::Migration
  def change
    add_index :contributions, :parent_id
  end
end
