# The Notification model is based off of the Activity model.
# The main difference is that the Notification model is per person.
class Notification < ActiveRecord::Base

  belongs_to :item, polymorphic: true
  belongs_to :person
  belongs_to :receiver, :class_name => 'Person'

  validates :item_id, presence: true
  validates :item_type, presence: true
  validates :item_created_at, presence: true
  validates :person_id, presence: true
  validates :receiver_id, presence: true

  VALID_TYPES = [ Conversation, Contribution, Issue, RatingGroup, SurveyResponse,
                  Petition, PetitionSignature, Reflection, ReflectionComment, Survey]

  delegate :name, :to => :person, :prefix => true

  # Items title
  # * Whitespace trimmed from the left and right
  def item_title
    item.title.strip
  end

  def item_content
    Sanitize.clean(item.content, :remove_contents => ['script', 'style']).strip
  end

  # Accept an Active Record object of valid type
  def initialize(attributes = nil)
    if Notification.valid_type?(attributes)
      attributes = attributes.becomes(Contribution) if attributes.is_a?(Contribution)
      attr = {
        item_id: attributes.id,
        item_type: attributes.class.to_s,
        item_created_at: attributes.created_at,
        person_id: attributes.person.id
      }
      if attributes.respond_to?(:conversation_id) && !attributes.conversation_id.nil?
        attr[:conversation_id] = attributes.conversation_id
      elsif attributes.respond_to?(:issue_id) && !attributes.issue_id.nil?
        attr[:issue_id] = attributes.issue_id
      elsif attributes.is_a?(Conversation)
        attr[:conversation_id] = attributes.id
      elsif attributes.is_a?(Vote)
        attr[:conversation_id] = attributes.surveyable_id if attributes.surveyable_type == 'Conversation'
      end

      attributes = attr
    elsif attributes.is_a?(ActiveRecord::Base)
      # if it's not a valid Notification type, and it's an activerecord object, then nullify it, because it breaks in rails >= 3.1 (Perry)
      attributes = nil
    end
    super(attributes)
  end

  def self.commented_on_created_reflection_notification(reflection_comment)
    if reflection_comment.reflection
      Notification.update_or_create_notification(reflection_comment, reflection_comment.person_id, reflection_comment.reflection.owner)
    end
  end

  def self.commented_on_commented_reflection_notification(reflection_comment)
    if reflection_comment.reflection
      Notification.update_or_create_notification(reflection_comment, reflection_comment.person_id, reflection_comment.reflection.commenter_ids)
    end
  end

  def self.contributed_on_created_conversation_notification(contribution)
    if contribution.conversation
      Notification.update_or_create_notification(contribution, contribution.owner, contribution.conversation.owner)
    end
  end

  def self.contributed_on_contribution_notification(contribution)
    if contribution.parent
      Notification.update_or_create_notification(contribution, contribution.owner, contribution.parent.owner)
    end
  end

  def self.contributed_on_followed_conversation_notification(contribution)
    if contribution.conversation
      Notification.update_or_create_notification(contribution, contribution.owner, contribution.conversation.subscriber_ids)
    end
  end

  def self.create_for(item)
    case item
    when Contribution
      self.contributed_on_created_conversation_notification(item)
      self.contributed_on_contribution_notification(item)
      self.contributed_on_followed_conversation_notification(item)
    when RatingGroup
      self.rated_on_contribution_notification(item)
      self.rated_on_followed_conversation_notification(item)
    when Reflection
      self.reflected_on_followed_conversation_notification(item)
    when SurveyResponse
      self.voted_on_followed_conversation_notification(item)
      self.voted_on_created_vote_notification(item)
      self.voted_on_voted_vote_notification(item)
    when PetitionSignature
      self.signed_petition_on_followed_conversation_notification(item)
      self.signed_on_created_petition_notification(item)
      self.signed_on_signed_petition_notification(item)
    when ReflectionComment
      self.commented_on_created_reflection_notification(item)
      self.commented_on_commented_reflection_notification(item)
    end
  end

  def self.destroy_commented_on_commented_reflection_notification(reflection_comment)
    if reflection_comment.reflection
      Notification.destroy_notification(reflection_comment, reflection_comment.person_id, reflection_comment.reflection.commenter_ids)
    end
  end

  def self.destroy_commented_on_created_reflection_notification(reflection_comment)
    if reflection_comment.reflection
      Notification.destroy_notification(reflection_comment, reflection_comment.person_id, reflection_comment.reflection.owner)
    end
  end

  def self.destroy_contributed_on_created_conversation_notification(contribution)
    if contribution.conversation
      Notification.destroy_notification(contribution, contribution.owner, contribution.conversation.owner)
    end
  end

  def self.destroy_contributed_on_contribution_notification(contribution)
    if contribution.parent
      Notification.destroy_notification(contribution, contribution.owner, contribution.parent.owner)
    end
  end

  def self.destroy_contributed_on_followed_conversation_notification(contribution)
    if contribution.conversation
      Notification.destroy_notification(contribution, contribution.owner, contribution.conversation.subscriber_ids)
    end
  end

  def self.destroy_rated_on_contribution_notification(rating_group)
    if rating_group.contribution
      Notification.destroy_notification(rating_group, rating_group.person_id, rating_group.contribution.owner)
    end
  end

  def self.destroy_rated_on_followed_conversation_notification(rating_group)
    if rating_group.conversation
      Notification.destroy_notification(rating_group, rating_group.person_id, rating_group.conversation.subscriber_ids)
    end
  end

  def self.destroy_reflected_on_followed_conversation_notification(reflection)
    if reflection.conversation
      Notification.destroy_notification(reflection, reflection.owner, reflection.conversation.subscriber_ids)
    end
  end

  def self.destroy_signed_petition_on_followed_conversation_notification(petition_signature)
    if petition_signature.petition && petition_signature.petition.conversation
      Notification.destroy_notification(petition_signature, petition_signature.person_id, petition_signature.petition.conversation.subscriber_ids)
    end
  end

  def self.destroy_for(item)
    case item
    when Contribution
      self.destroy_contributed_on_created_conversation_notification(item)
      self.destroy_contributed_on_contribution_notification(item)
      self.destroy_contributed_on_followed_conversation_notification(item)
    when RatingGroup
      self.destroy_rated_on_contribution_notification(item)
      self.destroy_rated_on_followed_conversation_notification(item)
    when Reflection
      self.destroy_reflected_on_followed_conversation_notification(item)
    when SurveyResponse
      self.destroy_voted_on_followed_conversation_notification(item)
      self.destroy_voted_on_created_vote_notification(item)
      self.destroy_voted_on_voted_vote_notification(item)
    when PetitionSignature
      self.destroy_signed_petition_on_followed_conversation_notification(item)
      self.destroy_signed_on_created_petition_notification(item)
      self.destroy_signed_on_signed_petition_notification(item)
    when ReflectionComment
      self.destroy_commented_on_created_reflection_notification(item)
      self.destroy_commented_on_commented_reflection_notification(item)
    end
  end

  def self.destroy_signed_on_created_petition_notification(petition_signature)
    if petition_signature.petition
      Notification.destroy_notification(petition_signature, petition_signature.person_id, petition_signature.petition.person_id)
    end
  end

  def self.destroy_signed_on_signed_petition_notification(petition_signature)
    if petition_signature.petition
      Notification.destroy_notification(petition_signature, petition_signature.person_id, petition_signature.petition.signer_ids)
    end
  end

  def self.destroy_notification(item, person_id, receiver_id)
    receiver_id.delete(person_id) if receiver_id.is_a?(Array)
    if person_id != receiver_id
      Notification.destroy_all(:item_id => item.id, :item_type => item.class.name, :person_id => person_id, :receiver_id =>  receiver_id)
    end
  end

  def self.destroy_voted_on_created_vote_notification(survey_response)
    if survey_response.survey && survey_response.survey.conversation
      Notification.destroy_notification(survey_response, survey_response.person_id, survey_response.survey.person_id)
    end
  end

  def self.destroy_voted_on_followed_conversation_notification(survey_response)
    if survey_response.survey && survey_response.survey.conversation
      Notification.destroy_notification(survey_response, survey_response.person_id, survey_response.survey.conversation.subscriber_ids)
    end
  end

  def self.destroy_voted_on_voted_vote_notification(survey_response)
    if survey_response.survey
      Notification.destroy_notification(survey_response, survey_response.person_id, survey_response.survey.respondent_ids)
    end
  end

  def self.signed_on_created_petition_notification(petition_signature)
    if petition_signature.petition
      Notification.update_or_create_notification(petition_signature, petition_signature.person_id, petition_signature.petition.person_id)
    end
  end

  def self.rated_on_contribution_notification(rating_group)
    if rating_group.contribution
      Notification.update_or_create_notification(rating_group, rating_group.person_id, rating_group.contribution.owner)
    end
  end

  def self.signed_petition_on_followed_conversation_notification(petition_signature)
    if petition_signature.petition && petition_signature.petition.conversation
      Notification.update_or_create_notification(petition_signature, petition_signature.person_id, petition_signature.petition.conversation.subscriber_ids)
    end
  end

  def self.signed_on_signed_petition_notification(petition_signature)
    if petition_signature.petition
      Notification.update_or_create_notification(petition_signature, petition_signature.person_id, petition_signature.petition.signer_ids)
    end
  end

  def self.rated_on_followed_conversation_notification(rating_group)
    if rating_group.conversation
      Notification.update_or_create_notification(rating_group, rating_group.person_id, rating_group.conversation.subscriber_ids)
    end
  end

  def self.reflected_on_followed_conversation_notification(reflection)
    if reflection.conversation
      Notification.update_or_create_notification(reflection, reflection.owner, reflection.conversation.subscriber_ids)
    end
  end

  def self.update_or_create_notification(item, person_id, receiver_id)
    if receiver_id.is_a?(Array)
      Notification.update_or_create_multiple_notifications(item, person_id, receiver_id)
    else
      Notification.update_or_create_single_notification(item, person_id, receiver_id)
    end
  end

  def self.update_or_create_single_notification(item, person_id, receiver_id)
    if person_id != receiver_id
      notification = Notification.where(:item_id => item.id, :item_type => item.class.name, :person_id => person_id, :receiver_id => receiver_id).first
      if notification
        notification.attributes = Notification.new(item).attributes
      else
        notification = Notification.new(item)
        notification.receiver_id = receiver_id
      end
      notification.save
      return notification
    end
  end

  def self.update_or_create_multiple_notifications(item, person_id, receiver_ids)
    receiver_ids.each do |receiver_id|
      Notification.update_or_create_single_notification(item, person_id, receiver_id)
    end
  end

  # Check if item is a valid type for Activity
  def self.valid_type?(item)
    ok = false
    VALID_TYPES.each do |type|
      if (item.is_a? Contribution and not item.top_level_contribution?)
        ok = true
        break
      elsif item.is_a? type and not item.is_a? Contribution
        ok = true
        break
      elsif item.is_a? GenericObject and item.__class__ == 'Contribution' and not item.top_level_contribution?
        ok = true
        break
      elsif item.is_a? GenericObject and item.__class__ == type.to_s and not item.__class__ == 'Contribution'
        ok = true
        break
      end
    end
    return ok
  end

  def self.voted_on_created_vote_notification(survey_response)
    if survey_response.survey
      Notification.update_or_create_notification(survey_response, survey_response.person_id, survey_response.survey.person_id)
    end
  end

  def self.voted_on_followed_conversation_notification(survey_response)
    if survey_response.survey && survey_response.survey.conversation
      Notification.update_or_create_notification(survey_response, survey_response.person_id, survey_response.survey.conversation.subscriber_ids)
    end
  end

  def self.voted_on_voted_vote_notification(survey_response)
    if survey_response.survey
      Notification.update_or_create_notification(survey_response, survey_response.person_id, survey_response.survey.respondent_ids)
    end
  end

  def viewed?
    !self.viewed_at.blank?
  end
  def not_viewed?
    self.viewed_at.blank?
  end

  def self.viewed(person)
    notifications = self.where("receiver_id = ?", person).where("viewed_at is null")
    notifications.update_all(:viewed_at => Time.now)
  end

end
