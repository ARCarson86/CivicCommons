class RemotePage < ActiveRecord::Base
  attr_accessible :description, :title, :url, :conversation, :source_key, :root_domain

  belongs_to :conversation

  has_many :contributions, dependent: :destroy, as: :contributable
  has_many :participants, through: :contributions, source: :person, order: 'contributions.created_at DESC'

  alias_method :contributors, :participants

  before_create :set_root_domain
  after_create :create_embeddly_info

  def top_level_contributions
    contributions.where parent_id: nil
  end

  def create_embeddly_info
    embedly = EmbedlyService.new
    info = embedly.fetch(url)
    unless info.blank?
      update_attributes title: info[:title], description: info[:description]
    end
  end

  def set_root_domain
    return if self.root_domain.present?
    return if self.remote_page_url.blank?

    uri = URI.parse self.remote_page_url
    return if url.nil?

    self.root_domain = uri.host
  end

end
