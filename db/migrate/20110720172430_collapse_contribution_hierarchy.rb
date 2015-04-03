class CollapseContributionHierarchy < ActiveRecord::Migration
  def self.up
    add_column :contributions, :top_level_contribution, :boolean, :default => false
    Contribution.unscoped.update_all('top_level_contribution = 1', 'type LIKE "TopLevelContribution"')
    remove_column :contributions, :type
  end

  def self.down
    add_column :contributions, :type, :string, :default => 'Contribution'
    Contribution.unscoped.update_all('type = "TopLevelContribution"', 'top_level_contribution = 1')
    remove_column :contributions, :top_level_contribution
  end
end
