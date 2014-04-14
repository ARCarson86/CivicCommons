class Conversation < ActiveRecord::Base
  extend FriendlyId
  include Visitable
  include Subscribable
  include Regionable
  include GeometryForStyle
  include HomepageFeaturable
  include Thumbnail

  attr_accessor :agree_to_be_civil, :other_topic

  has_many :actions, :dependent => :destroy
  has_many :activities

  searchable :ignore_attribute_changes_of => [ :total_visits, :recent_visits, :last_visit_date, :updated_at, :recent_rating ] do
    text :title, :boost => 3, :default_boost => 3
    text :summary, :stored => true, :boost => 2, :default_boost => 2 do
      Sanitize.clean(summary, :remove_contents => ['style','script'])
    end
    integer :region_metrocodes, :multiple => true
  end
  has_many :contributions, :dependent => :destroy
  has_many :confirmed_contributions, :class_name => 'Contribution',
           :conditions => ['confirmed = ?', true]
  accepts_nested_attributes_for :contributions, :allow_destroy => true

  has_many :subscriptions, :as => :subscribable, :dependent => :destroy
  has_many :featured_opportunities, :dependent => :nullify

  def top_level_contributions
    Contribution.where(:conversation_id => self.id, :top_level_contribution => true)
  end

  # any person that has made a contribution to the convo
  has_many :contributors, :through => :confirmed_contributions,
           :source => :person, :uniq => true,
           :order => "contributions.created_at ASC"

  has_many :petitions, :dependent => :destroy
  has_many :reflections, :dependent => :destroy

  has_and_belongs_to_many :issues

  has_many :conversations_topics, :dependent => :destroy
  has_many :topics, :through => :conversations_topics, :uniq => true
  validates_length_of :topics, :minimum => 1, :message => 'Please select at least one topic for your conversation', :if => 'self.other_topic.nil?'

  accepts_nested_attributes_for :topics

  has_many :conversations_people, :uniq => true, :dependent => :destroy
  has_many :people, :through => :conversations_people, :foreign_key => 'conversation_id', uniq: true

  def moderators
    self.people
  end

  def moderated_by?(person)
    if person
      moderators.include?(person)
    end
  end

  has_many :content_items_conversations, :uniq => true
  has_many :content_items, :through => :content_items_conversations, uniq: true
  has_many :surveys, :as => :surveyable

  belongs_to :person, :foreign_key => "owner"
  belongs_to :metro_region

  delegate :name, :to => :person, :prefix => true
  delegate :standard_issue, :to => :issues
  delegate :managed_issue, :to => :issues
  delegate :city_display_name, :to => :metro_region, :prefix => true, :allow_nil => true

  has_attached_file :image,
    :styles => {
       :normal => "480x300#",
       :panel => "198x130#"},
    :storage => :s3,
    :s3_credentials => S3Config.credential_file,
    :path => IMAGE_ATTACHMENT_PATH,
    :default_url => 'convo_img_:style.gif'
  validates_attachment_content_type :image,
                                    :content_type => /image\/*/,
                                    :message => "Not a valid image file."
  validates :owner, :must_be_logged_in => true

  validates_presence_of :owner, :message => "You must be logged in."
  validates_presence_of :title, :message => "Please choose a title for your conversation."
  validates_length_of :title, :maximum => 50, :message => 'Please enter a title with less than 50 characters', :on => :create
  validates_presence_of :summary, :message => "Please give us a short summary."
  validates_format_of :link, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix, :on => :create, :allow_blank => true, :message => "Link must look like a url (example http://google.com)."
  validates_presence_of :zip_code, :message => "Please give us a zip code for a little geographic context."
  validates_presence_of :metro_region_id, :message => 'Please give us a Location name.'

  after_create :set_initial_position, :subscribe_creator
  around_create :send_notification_on_other_topic

  friendly_id :title, :use => :slugged
  def should_generate_new_friendly_id?
    new_record? || slug.nil?
  end

  def send_notification_on_other_topic
    other_topic = self.other_topic
    yield
    Notifier.other_conversation_topic_selected(self).deliver if other_topic
  end

  scope :latest_updated, :order => 'updated_at DESC'
  scope :latest_created, where(:exclude_from_most_recent => false).order('created_at DESC')
  scope :alphabet_ascending_by_title, :order => 'title ASC'
  scope :staff_picked, where(:staff_pick => true)
  scope :sort_position_asc, order('position ASC')

  # Filters by metro region, if metrocode parameter is supplied, otherwise, ignores it.
  scope :filter_metro_region, lambda{|metrocode| joins(:metro_region).where(:metro_regions=>{metrocode: metrocode}) if metrocode.present?}


  # position starts from 0, and so forth
  def move_to_position(new_position)
    if new_position.is_a?(Integer)
      conversations = Conversation.sort_position_asc.select([:id,:position]).where(['id != ?', self.id]).all
      self.transaction do
        conversations.each_with_index do |conversation, index|
          if index >= new_position
            new_index = index + 1
          else
            new_index = index
          end
          Conversation.where(:id=>conversation.id).update_all(:position => (new_index))
        end
        Conversation.where(:id=>self.id).update_all(:position => new_position)
      end
    end
  end

  # Return conversations that have actions and reflections.
  def self.conversations_with_actions_and_reflections
    actions = Action.all
    action_conversations = actions.collect{|action| action.conversation}

    reflections = Reflection.all
    reflection_conversations = reflections.collect{|reflection| reflection.conversation}

    action_conversations & reflection_conversations
  end

  # Number of Contributors in this Conversation
  def community_user_ids
    rater_ids = RatingGroup.select(:person_id).where(contribution_id: contribution_ids).uniq.collect do |rating_group|
      rating_group.person_id
    end
    person_ids = Array.new
    person_ids += [owner]
    person_ids += contributor_ids
    person_ids += rater_ids
    person_ids = person_ids.flatten.uniq.reject(&:blank?)
    people = Person.select(:id).where(:id => person_ids).where('confirmed_at IS NOT NULL and locked_at IS NULL')
    people.collect{ |person| person.id }
  end

  # Number of Participants in related to the Talk portion of this Conversation
  def participants
    persons = Person.select("people.*, MAX(contributions.created_at) as most_recent_contribution").joins(:contributions).where("contributions.conversation_id = ?", self.id).order("most_recent_contribution DESC").group("people.id")
    persons.flatten.uniq.reject(&:blank?)
  end
  # Number of Action Participants Related to this Conversation
  #
  # * Originator of Action
  # * Number of people signing
  # * Number of people voting
  def action_participants
    actions.collect(&:participants).flatten.uniq
  end

  # Number of Action Participants Related to this Conversation
  #
  # * Originator of Action
  # * Number of people signing
  # * Number of people voting
  def action_participants_count
    action_participants.count
  end

  def petition_actions_count
    self.actions.select{|a| a.is_petition?}.count
  end

  def ballot_actions_count
    self.actions.select{|a| a.is_ballot?}.count
  end

  # Reflection Participants Related to this Conversation
  #
  # * Number of people posting Reflection or Comments
  def reflection_participants
    reflections.collect(&:participants).flatten.uniq
  end

  # Number of Reflection Participants Related to this Conversation
  #
  # * Number of people posting Reflection or Comments
  def reflection_participants_count
    reflection_participants.count
  end

  # region_metrocodes is plural because this method is available across several models, which is used to index the metrocodes in Solr.
  def region_metrocodes
    [metro_region.metrocode].compact if metro_region_id.present? &&  metro_region.present?
  end


  def self.available_filters
    {
      :recommended => :recommended,
      :active => :most_active,
      :recent => :latest_created
    }
  end

  def self.available_filter_names
    available_filters.keys.collect(&:to_s)
  end

  # Display Conversations by Most Active
  def self.most_active(options = {})
    options.reverse_merge!(filter:0)
    daysago = options.delete(:daysago)

    filter = options[:filter]
    filter = [filter] unless options[:filter].respond_to?(:flatten) || filter.nil?
    filter.flatten!

    results = Conversation.select('conversations.*, COUNT(*) AS count_all, MAX(contributions.created_at) AS max_contributions_created_at').
                     joins('LEFT OUTER JOIN contributions ON conversations.id = contributions.conversation_id').
                     where("conversations.id not in (?)", filter).
                     group('conversations.id').
                     order('count_all DESC, max_contributions_created_at DESC')

    results = results.where("contributions.created_at > ?", Time.now - daysago.days) if daysago
    return results
  end

  # From the top active conversations, select a random sample.
  #
  # limit = number of most active conversations to select from (default 4)
  # select = number of random conversations to select (default 2)
  def self.random_active(select=2, limit=4, filter = [])
    filter = [filter] unless filter.respond_to?(:flatten)
    filter.flatten!

    limit = select if select > limit

    actives = Conversation.most_active - filter
    actives = actives[0,limit]
    actives.sample(select)
  end

  def self.random_recommended(select=1, filter = [])
    filter = [filter] unless filter.respond_to?(:flatten)
    filter.flatten!

    r = Conversation.recommended
    r = r - filter
    r.sample(select)
  end

  def self.recommended(options = {})
    options.reverse_merge!(filter:0)
    filter = options[:filter]
    filter = [filter] unless options[:filter].respond_to?(:flatten) || filter.nil?
    filter.flatten!

    Conversation.where('staff_pick = true').
                 where("conversations.id not in (?)", filter).
                 order('position ASC')
  end

  def self.filtered(filter)
    raise "Undefined Filter :#{filter}" unless available_filter_names.include?(filter)
    scoped.merge(self.send(available_filters[filter.to_sym]))
  end

  def self.sort
    conversations = Conversation.order('staff_pick DESC, position ASC, id ASC')
    staff_picks = conversations.select { |c| c.staff_pick? }
    others = conversations - staff_picks

    staff_picks.each_with_index do |conversation, i|
      Conversation.where('id = ?', conversation.id).update_all(position: i)
    end

    staff_picks_length = staff_picks.length
    others.each_with_index do |conversation, i|
      Conversation.where('id = ?', conversation.id).update_all(position: i + staff_picks_length)
    end
  end

  def user_generated?
    from_community
  end

  def sort
    max_position = Conversation.where('staff_pick = true').maximum('position')
    Conversation.where('id = ?', self.id).update_all(position: max_position + 1) if max_position
    Conversation.sort
  end

  def staff_pick?
    staff_pick
  end

  # Return a comma-and-space-delimited list of the Issues
  # relevant to this Conversation, e.g., "Jobs, Sports, Religion"
  def issues_text
    if issues.any?
       issues.map(&:name).join(", ")
    else
      "No issues yet"
    end
  end


  # Original plan: single Moderator per Conversation.
  # New plan: Zero or more Guides per Conversation.
  # validates :moderator, :presence => :true

  def guides_text
    if (guides.count > 0)
      guides.join(", ")
    else
      "No Guides yet"
    end
  end

  def start_month_text
    if started_at.nil?
      "?"
    else
      started_at.strftime("%B")
    end
  end

  def start_day
    if started_at.nil?
      "?"
    else
      started_at.mday
    end
  end

  def set_initial_position
    max = Conversation.maximum(:position)
    if max
     self.update_attribute(:position, max + 1)
    else
      self.update_attribute(:position, 0)
    end
  end

  def subscriber_ids
    subscriptions ? subscriptions.collect(&:person_id) : []
  end

  def subscribe_creator
    Subscription.create_unless_exists(person, self)
  end

  def metro_region_city_display_name=(record)
    # ignore this attribute that comes back from form post, on a delegator method.
    return true
  end

  # Due to caching, we need to update the issue updated_at timestamp
  #   so we can automatically expire the old cache.
  # Conversations do not have issues when they are created so we don't
  #   need to do this after_save, only when an admin adds a convo to
  #   an issue or project.
  def touch_issues
    self.issues.each do |issue|
      issue.touch
    end
  end

end
