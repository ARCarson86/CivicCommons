class ReflectionComment < ActiveRecord::Base
  belongs_to :reflection
  belongs_to :person
  validates_presence_of :body

  def conversation_id
    try(:reflection).try(:conversation_id)
  end

  def title
    try(:reflection).try(:title)
  end

end
