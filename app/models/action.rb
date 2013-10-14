class Action < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :actionable, :polymorphic => true
  has_and_belongs_to_many :reflections
  has_and_belongs_to_many :featured_opportunities, :join_table => :featured_opportunities_actions, :uniq => true
  validates_presence_of :conversation_id,
                        :actionable_id,
                        :actionable_type

  # the other end of actionable must have participants method
  delegate :participants, :to => :actionable

  delegate :title, :to => :actionable

  def one_line_summary
    [actionable.person.name, actionable.title, actionable.description].delete_if(&:blank?).join(' - ')
  end

  def is_petition?
    self.actionable_type == "Petition"
  end

  def is_ballot?
    self.actionable_type == "Survey"
  end
end
