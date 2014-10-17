class RemotePage < ActiveRecord::Base
  attr_accessible :description, :title, :url

  has_many :contributions, dependent: :destroy, as: :contributable
  has_many :participants, through: :contributions, source: :person, order: 'contributions.created_at DESC'
  alias_method :contributors, :participants

  def top_level_contributions
    contributions.where parent_id: nil
  end

end
