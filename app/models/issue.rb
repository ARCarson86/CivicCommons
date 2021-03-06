class Issue < ActiveRecord::Base
  extend FriendlyId
  include Visitable
  include Subscribable
  include Regionable
  include GeometryForStyle
  include HomepageFeaturable
  include Thumbnail

  searchable :ignore_attribute_changes_of => [ :total_visits, :recent_visits, :last_visit_date, :updated_at, :recent_rating ] do
    text :name, :boost => 3, :default_boost => 3
    text :summary, :stored => true, :boost => 2, :default_boost => 2 do
      Sanitize.clean(summary, :remove_contents => ['style','script'])
    end
    string :type
    integer :region_metrocodes, :multiple => true
  end

  ALL_TYPES = ['Issue', 'ManagedIssue']

  belongs_to :person

  has_and_belongs_to_many :conversations, order: "created_at DESC"
  has_many :issues_topics, uniq: true
  has_many :topics, through: :issues_topics, uniq: true

  has_many :conversation_contributions, through: :conversations, source: :contributions
  has_many :convo_participants, through: :conversations, source: :participants, uniq: true

  # Contributions directly related to this Issue
  has_many :contributions
  has_many :suggested_actions
  has_many :surveys, :as => :surveyable
  has_many :votes, :as => :surveyable, :class_name => 'Survey', :conditions => {:type => 'Vote'}
  has_many(:media_contributions, :class_name => "Contribution",
           :conditions => {:type => ['EmbeddedSnippet', 'Link', 'AttachedFile']})

  has_many :subscriptions, :as => :subscribable, :dependent => :destroy

  # Anyone who has contributed directly to the issue via a contribution
  has_many(:participants,
           :through => :contributions,
           :source => :person,
           :uniq => true)

  has_attached_file(:image,
                    :styles => {
                      :normal => "480x300#",
                      :panel => "198x130#" },
                    :storage => :s3,
                    :s3_credentials => S3Config.credential_file,
                    :path => IMAGE_ATTACHMENT_PATH)
  validates_attachment_content_type :image,
                                    :content_type => /image\/*/,
                                    :message => "Not a valid image file."

  has_attached_file(:standard_banner_image,
                    :styles => {
                      :normal => '940x100#',
                      :panel => "198x130#" },
                    :storage => :s3,
                    :s3_credentials => S3Config.credential_file,
                    :path => IMAGE_ATTACHMENT_PATH)
  validates_attachment_content_type :standard_banner_image,
                                    :content_type => /image\/*/,
                                    :message => "Not a valid image file."

  friendly_id :name, :use => :slugged
  def should_generate_new_friendly_id?
    new_record? || slug.nil?
  end

  before_create :assign_position

  before_save :touch_conversations

  validates :name, :presence => true, :length => { :minimum => 5 }
  validate :require_topic
  validates_uniqueness_of :name
  validates_attachment_presence :image

  scope :standard_issue, where(:type => 'Issue')
  scope :managed_issue, where(:type => 'ManagedIssue')

  scope(:most_active, :select =>
        'count(1) as contribution_count, issues.*',
        :joins => [:contributions],
        :group => "issues.id",
        :order => 'contribution_count DESC')
  scope :custom_order, {:order => 'position ASC'}
  scope :most_recent, {:order => 'created_at DESC'}
  scope :most_recent_update, {:order => 'updated_at DESC'}
  scope :published, where(:exclude_from_result => false)
  scope :alphabetical, {:order => 'name ASC'}
  scope :sort, lambda { |sort_type|
      case sort_type
      when 'most_recent'
        most_recent
      when 'alphabetical'
        alphabetical
      when 'most_recent_update'
        most_recent_update
      when 'most_active'
        most_active
      else
        custom_order
      end
    }
  # Filters by metro region, if metrocode parameter is supplied, otherwise, ignores it.
  scope :filter_metro_region, lambda{|metrocode|
      joins(:conversations => :metro_region).where(:metro_regions=>{metrocode: metrocode}).group('issues.id') if metrocode.present?
    }


  def self.random
    if (c = count) != 0
      find(:first, :offset =>rand(c))
    end
  end

  def self.sample(count=1)
    result = []

    until result.size == count do
      random_issue = self.random
      result << random_issue if !result.include?(random_issue)
    end
    result
  end

  def self.assign_positions
    non_nil_positions = Issue.where('position IS NOT NULL').order('position ASC, id ASC')
    nil_positions = Issue.where('position IS NULL').order('position ASC, id ASC')

    non_nil_positions.each_with_index do |issue, i|
      issue.update_attribute(:position, i)
    end
    nil_positions.each_with_index do |issue, i|
      issue.update_attribute(:position, i + non_nil_positions.size)
    end
  end

  def self.set_position(current_position, next_position, previous_position)
    if previous_position.nil?
      self.update_positions(current_position, 0, next_position)
    elsif next_position.nil?
      self.update_positions(current_position, Issue.maximum('position') + 2, previous_position)
    elsif next_position > previous_position
      self.update_positions(current_position, previous_position + 1, next_position)
    elsif next_position < previous_position
      self.update_positions(current_position, next_position + 1, previous_position)
    end
    Issue.assign_positions
  end

  def self.top_issues
    Issue.all.sort_by do |issue|
      issue.activity_weight
    end
  end

  def activity_weight
    visits = self.visits.count
    contributions = self.contributions.count

    @activity_weight = visits + contributions
  end

  def conversation_comments
    Contribution.joins(:conversation).where({:conversations => {:id => self.conversation_ids}})
  end

  def conversation_contributer_ids
    self.conversations.collect do |conversation|
      conversation.contributors.pluck :id
    end.uniq
  end

  def conversation_creators_ids
    self.conversations.collect do |conversation|
      conversation.owner
    end.uniq
  end

  def conversation_rater_ids
    contribution_ids = self.conversations.collect do |conversation|
      conversation.contribution_ids
    end.uniq
    RatingGroup.select(:person_id).where(contribution_id: contribution_ids).uniq.collect do |rating_group|
      rating_group.person_id
    end
  end

  # Determine the user ids for participants of this issue.
  def community_user_ids
    person_ids = Array.new
    person_ids += participants.pluck :id
    person_ids += conversation_creators_ids
    person_ids += conversation_contributer_ids
    person_ids += conversation_rater_ids
    person_ids = person_ids.flatten.uniq.reject(&:blank?)
    people = Person.select(:id).where(:id => person_ids).where('confirmed_at IS NOT NULL and locked_at IS NULL')
    people.collect{ |person| person.id }
  end

  def most_active_users
    Person.find_confirmed_order_by_most_active(community_user_ids)
  end

  def most_newest_users
    Person.find_confirmed_order_by_recency(community_user_ids)
  end

  def order_by_alpha_users(letter = nil)
    Person.find_confirmed_order_by_last_name(letter, community_user_ids)
  end

  def managed?
    false
  end

  def has_topic?(topic)
    topics.include?(topic)
  end

  define_method(:title) do
    name
  end

  def region_metrocodes
    conversations.collect do |conversation|
      conversation.metro_region.metrocode if conversation.metro_region_id.present? &&  conversation.metro_region.present?
    end.compact.uniq
  end

  #validation
  def require_topic
    errors.add(:base, "Please select at least one Topic") if self.topic_ids.blank?
  end


  protected
  def touch_conversations
    Rails.logger.info "Touched Conversations"
    conversations.each do |conversation|
      conversation.touch
    end
  end

  private

  def self.update_positions(current, new_index, comparison)
    current_issue = Issue.find_by_position(current)
    Issue.where('position >= ?', comparison).each do |issue|
      issue.position += 1
      issue.save
    end
    current_issue.position = new_index
    current_issue.save
  end

  def assign_position
    if self.position.nil?
      self.position = Issue.maximum('position') ? Issue.maximum('position') + 1 : 0
    end
  end

end
