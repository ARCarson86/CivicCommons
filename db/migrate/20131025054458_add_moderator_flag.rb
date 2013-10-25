class AddModeratorFlag < ActiveRecord::Migration
  def self.up
    add_column :contributions, :moderator_post, :boolean
  end

  def self.down
    remove_column :contributions, :moderator_post
  end
end
