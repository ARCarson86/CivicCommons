class Reflection < ActiveRecord::Base
  belongs_to :person, :foreign_key => "owner"
  belongs_to :conversation
  has_many :comments, :class_name => 'ReflectionComment', :dependent => :destroy
  has_and_belongs_to_many :actions
  has_and_belongs_to_many :featured_opportunities, :join_table => :featured_opportunities_reflections, :uniq => true

  validates_presence_of :title
  validates_presence_of :details

  attr_accessible :action_ids
  attr_accessible :title, :details, :conversation_id, :owner

  # Owner/Creator of this reflection
  def owner_name
    self.person.name
  end
  
  def commenter_ids
    comments.collect(&:person_id)
  end

  # Actions related to owner of this reflection
  def owner_participated_actions
    self.person.participated_actions
  end

  # Actionables related to this reflection
  def related_actionables
    action.actionable
  end

  def one_line_summary
    [person.name,title,details].delete_if(&:blank?).join(' - ')
  end

  # People Posting the Reflection or Comments to the Reflection
  def participants
    ([self.owner] + self.comments.collect(&:person_id)).flatten.uniq
  end

end
