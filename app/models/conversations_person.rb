class ConversationsPerson < ActiveRecord::Base
  belongs_to :conversation, touch: true
  belongs_to :person, touch: true

end
