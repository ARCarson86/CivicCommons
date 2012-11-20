class AddManualResultsToSurvey < ActiveRecord::Migration
  def self.up
    add_column :surveys, :manual_results, :boolean
  end

  def self.down
    remove_column :surveys, :manual_results
  end
end
