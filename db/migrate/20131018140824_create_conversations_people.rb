class CreateConversationsPeople < ActiveRecord::Migration
  def change
    create_table :conversations_people, :force => true do |t|
      t.integer :conversation_id
      t.integer :person_id
      t.timestamps
    end
    add_index :conversations_people, [:conversation_id, :person_id]
  end
end
