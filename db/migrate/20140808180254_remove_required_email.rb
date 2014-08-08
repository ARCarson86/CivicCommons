class RemoveRequiredEmail < ActiveRecord::Migration
  def change
  	change_column :people, :email, :string, null: true
  end
end
