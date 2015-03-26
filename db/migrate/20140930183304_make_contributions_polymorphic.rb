class MakeContributionsPolymorphic < ActiveRecord::Migration
  def up
    rename_column :contributions, :conversation_id, :contributable_id
    add_column :contributions, :contributable_type, :string
    Contribution.reset_column_information
    Contribution.update_all contributable_type: "Conversation"
  end

  def down
    rename_column :contributions, :contributable_id, :conversation_id
    remove_column :contributions, :contributable_type
  end
end
