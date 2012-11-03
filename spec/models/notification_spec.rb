require 'spec_helper'

describe Notification do
  def given_a_contribution_with_conversation
    @contribution = FactoryGirl.create(:contribution)
  end

  def given_a_contribution_with_parent_contribution
    @parent_contribution = FactoryGirl.create(:contribution)
    @contribution = FactoryGirl.create(:contribution,:conversation_id => @parent_contribution.conversation.id, :parent_id => @parent_contribution.id)
  end

  def given_contribution_with_conversation_and_subscriptions
    @conversation = FactoryGirl.create(:conversation)
    @subscription = FactoryGirl.create(:conversation_subscription, :subscribable => @conversation)
    @contribution = FactoryGirl.create(:contribution, :conversation => @conversation)
  end

  def given_rating_group_with_contribution_with_conversation_and_subscriptions
    @conversation = FactoryGirl.create(:conversation)
    @subscription = FactoryGirl.create(:conversation_subscription, :subscribable => @conversation)
    @contribution = FactoryGirl.create(:contribution, :conversation => @conversation)
    @rating_group = FactoryGirl.create(:rating_group, :contribution => @contribution)
  end

  def given_survey_response_with_conversation_and_subscriptions
    @conversation = FactoryGirl.create(:conversation)
    @subscription = FactoryGirl.create(:conversation_subscription, :subscribable => @conversation)
    @vote = FactoryGirl.create(:vote, :surveyable => @conversation)
    @survey_response = FactoryGirl.create(:survey_response, :survey => @vote)
  end

  def given_3_survey_responses_with_vote
    @vote = FactoryGirl.create(:vote, :surveyable => @conversation)
    @survey_response = FactoryGirl.create(:survey_response, :survey => @vote)
    @survey_response2 = FactoryGirl.create(:survey_response, :survey => @vote)
    @survey_response3 = FactoryGirl.create(:survey_response, :survey => @vote)
  end

  def given_petition_signature_with_conversation_and_subscriptions
    @conversation = FactoryGirl.create(:conversation)
    @subscription = FactoryGirl.create(:conversation_subscription, :subscribable => @conversation)
    @petition = FactoryGirl.create(:unsigned_petition, :conversation => @conversation)
    @petition_signature = FactoryGirl.create(:petition_signature, :petition => @petition)
  end

  def given_3_petition_signatures
    @petition = FactoryGirl.create(:petition, :conversation => @conversation)
    @petition_signature = FactoryGirl.create(:petition_signature, :petition => @petition)
    @petition_signature2 = FactoryGirl.create(:petition_signature, :petition => @petition)
    @petition_signature3 = FactoryGirl.create(:petition_signature, :petition => @petition)
    @petition.reload
  end

  def given_reflection_with_conversation_and_subscriptions
    @conversation = FactoryGirl.create(:conversation)
    @subscription = FactoryGirl.create(:conversation_subscription, :subscribable => @conversation)
    @reflection = FactoryGirl.create(:reflection, :conversation => @conversation)
  end

  def given_reflection_comment_with_reflection
    @reflection = FactoryGirl.create(:reflection)
    @reflection_comment = FactoryGirl.create(:reflection_comment, :reflection => @reflection)
  end

  def given_3_reflection_comments
    @reflection = FactoryGirl.create(:reflection)
    @reflection_comment = FactoryGirl.create(:reflection_comment, :reflection => @reflection)
    @reflection_comment2 = FactoryGirl.create(:reflection_comment, :reflection => @reflection)
    @reflection_comment3 = FactoryGirl.create(:reflection_comment, :reflection => @reflection)
  end

  def given_a_rating_group
    @rating_group = FactoryGirl.create(:rating_group)
  end

  describe "update_or_create_notification" do
    it "should save a notification if it exists" do
      given_a_contribution_with_conversation
      Notification.update_or_create_notification(@contribution, @contribution.owner, 123)
      Notification.count.should == 1
      Notification.update_or_create_notification(@contribution, @contribution.owner, 123)
      Notification.count.should == 1
    end
    it "should create a notification if it doesn't exist" do
      given_a_contribution_with_conversation
      Notification.count.should == 0
      Notification.update_or_create_notification(@contribution, @contribution.owner, 123)
      Notification.count.should == 1
    end
    it "should not create a notification if person_id and receiver_id is the same" do
      given_a_contribution_with_conversation
      Notification.count.should == 0
      Notification.update_or_create_notification(@contribution, @contribution.owner, @contribution.owner)
      Notification.count.should == 0
    end
    it "should create multiple notifications if receiver_ids array is passed" do
      given_a_contribution_with_conversation
      Notification.count.should == 0
      Notification.update_or_create_notification(@contribution, @contribution.owner, [100,200,300])
      Notification.count.should == 3
    end
  end

  describe "destroy_notification" do
    it "should destroy the notification" do
      given_a_contribution_with_conversation
      Notification.update_or_create_notification(@contribution, @contribution.owner, 123)
      Notification.update_or_create_notification(@contribution, @contribution.owner, 999)
      Notification.count.should == 2
      Notification.destroy_notification(@contribution, @contribution.owner, 123)
      Notification.count.should == 1
    end
    it "should not do anything if person_id and receiver_id is the same" do
      given_a_contribution_with_conversation
      Notification.should_not_receive(:destroy_all)
      Notification.destroy_notification(@contribution, @contribution.owner, @contribution.owner)
    end
    it "should allow receiver_ids to be an array" do
      given_a_contribution_with_conversation
      Notification.should_receive(:destroy_all).with(hash_including(:receiver_id => [100,200,300]))
      Notification.destroy_notification(@contribution, @contribution.owner,[100,200,300])
    end
  end

  describe "with Contribution" do
    describe "contributed_on_created_conversation_notification" do
      it "should create notification to the contribution's conversation's owner" do
        given_a_contribution_with_conversation
        Notification.contributed_on_created_conversation_notification(@contribution)
        Notification.last.receiver_id.should == @contribution.conversation.owner
      end
      it "should not create a notification if conversation doesn't exist" do
        given_a_contribution_with_conversation
        @contribution.conversation = nil
        @contribution.save
        Notification.contributed_on_created_conversation_notification(@contribution)
        Notification.count.should == 0
      end
    end

    describe "contributed_on_contribution_notification" do
      it "should create notification to the contribution's parent's owner" do
        given_a_contribution_with_parent_contribution
        Notification.contributed_on_contribution_notification(@contribution)
        Notification.last.receiver_id.should == @parent_contribution.owner
      end
      it "should not create a notification if parent doesn't exist" do
        given_a_contribution_with_parent_contribution
        @contribution.parent = nil
        @contribution.save
        Notification.contributed_on_contribution_notification(@contribution)
        Notification.count.should == 0
      end
    end

    describe "contributed_on_followed_conversation_notification" do
      it "should create multiple records on followers of conversation" do
        given_contribution_with_conversation_and_subscriptions
        Notification.contributed_on_followed_conversation_notification(@contribution)
        Notification.count.should == 2
      end
      it "should send to the correct receivers" do
        given_contribution_with_conversation_and_subscriptions
        Notification.contributed_on_followed_conversation_notification(@contribution)
        (Notification.all.collect(&:receiver_id) - @conversation.subscriptions.collect(&:person_id)).should == []
      end
    end

    describe "destroy_contributed_on_created_conversation_notification" do
      it "should destroy the Notification record" do
        given_a_contribution_with_conversation
        Notification.contributed_on_created_conversation_notification(@contribution)
        Notification.count.should == 1
        Notification.destroy_contributed_on_created_conversation_notification(@contribution)
        Notification.count.should == 0
      end
    end
    describe "destroy_contributed_on_contribution_notification" do
      it "should destroy the Notification record" do
        given_a_contribution_with_parent_contribution
        Notification.contributed_on_contribution_notification(@contribution)
        Notification.count.should == 1
        Notification.destroy_contributed_on_contribution_notification(@contribution)
        Notification.count.should == 0
      end
    end

    describe "destroy_contributed_on_followed_conversation_notification" do
      it "should destroy the Notification records" do
        given_contribution_with_conversation_and_subscriptions
        Notification.contributed_on_followed_conversation_notification(@contribution)
        Notification.count.should == 2
        Notification.destroy_contributed_on_followed_conversation_notification(@contribution)
        Notification.count.should == 0
      end
    end


  end

  context "with RatingGroup" do
    describe "rated_on_contribution_notification" do
      it "should create the notification record" do
        given_a_rating_group
        Notification.count.should == 0
        Notification.rated_on_contribution_notification(@rating_group)
        Notification.count.should == 1
      end
      it "should set the rating group creator as person_id" do
        given_a_rating_group
        Notification.rated_on_contribution_notification(@rating_group)
        Notification.last.person_id.should == @rating_group.person_id
      end
      it "should set the rating group's contribution's owner as receiver_id" do
        given_a_rating_group
        Notification.rated_on_contribution_notification(@rating_group)
        Notification.last.receiver_id.should == @rating_group.contribution.owner
      end
    end

    describe "rated_on_followed_conversation_notification" do
      it "should create multiple records on followers of conversation" do
        given_rating_group_with_contribution_with_conversation_and_subscriptions
        Notification.rated_on_followed_conversation_notification(@rating_group)
        Notification.count.should == 2
      end
      it "should send to the correct receivers" do
        given_rating_group_with_contribution_with_conversation_and_subscriptions
        Notification.rated_on_followed_conversation_notification(@rating_group)
        (Notification.all.collect(&:receiver_id) - @conversation.subscriptions.collect(&:person_id)).should == []
      end
    end

    describe "destroy_rated_on_contribution_notification" do
      it "should destroy the notification record" do
        given_a_rating_group
        Notification.rated_on_contribution_notification(@rating_group)
        Notification.count.should == 1
        Notification.destroy_rated_on_contribution_notification(@rating_group)
        Notification.count.should == 0
      end
    end

    describe "destroy_rated_on_followed_conversation_notification" do
      it "should destroy the notification record" do
        given_rating_group_with_contribution_with_conversation_and_subscriptions
        Notification.rated_on_followed_conversation_notification(@rating_group)
        Notification.count.should == 2
        Notification.destroy_rated_on_followed_conversation_notification(@rating_group)
        Notification.count.should == 0
      end
    end
  end

  context "with SurveyResponse" do
    describe "voted_on_created_vote_notification" do
      it "should create the notification record" do
        given_survey_response_with_conversation_and_subscriptions
        Notification.count.should == 0
        Notification.voted_on_created_vote_notification(@survey_response)
        Notification.count.should == 1
      end
      it "should set the correct person_id" do
        given_survey_response_with_conversation_and_subscriptions
        Notification.voted_on_created_vote_notification(@survey_response)
        Notification.last.person_id.should == @survey_response.person_id
      end
      it "should set correct receiver_id" do
        given_survey_response_with_conversation_and_subscriptions
        Notification.voted_on_created_vote_notification(@survey_response)
        Notification.last.receiver_id.should == @survey_response.survey.person_id
      end
    end
    describe "voted_on_followed_conversation_notification" do
      it "should create multiple records on followers of conversation" do
        given_survey_response_with_conversation_and_subscriptions
        Notification.voted_on_followed_conversation_notification(@survey_response)
        Notification.count.should == 2
      end
      it "should send to the correct receivers" do
        given_survey_response_with_conversation_and_subscriptions
        Notification.voted_on_followed_conversation_notification(@survey_response)
        (Notification.all.collect(&:receiver_id) - @conversation.subscriptions.collect(&:person_id)).should == []
      end
    end
    describe "voted_on_voted_vote_notification" do
      it "should create multiple records on followers of conversation" do
        given_3_survey_responses_with_vote
        Notification.voted_on_voted_vote_notification(@survey_response)
        Notification.count.should == 2
      end
      it "should send to the correct receivers" do
        given_3_survey_responses_with_vote
        Notification.voted_on_followed_conversation_notification(@survey_response)
        (Notification.all.collect(&:receiver_id) - @vote.respondent_ids).should == []
      end
    end
    describe "destroy_voted_on_created_vote_notification" do
      it "should destroy the notification record" do
        given_survey_response_with_conversation_and_subscriptions
        Notification.voted_on_created_vote_notification(@survey_response)
        Notification.count.should == 1
        Notification.destroy_voted_on_created_vote_notification(@survey_response)
        Notification.count.should == 0
      end
    end
    describe "destroy_voted_on_followed_conversation_notification" do
      it "should destroy the notification record" do
        given_survey_response_with_conversation_and_subscriptions
        Notification.voted_on_followed_conversation_notification(@survey_response)
        Notification.count.should == 2
        Notification.destroy_voted_on_followed_conversation_notification(@survey_response)
        Notification.count.should == 0
      end
    end
    describe "destroy_voted_on_followed_conversation_notification" do
      it "should destroy the notification record" do
        given_3_survey_responses_with_vote
        Notification.voted_on_voted_vote_notification(@survey_response)
        Notification.count.should == 2
        Notification.destroy_voted_on_voted_vote_notification(@survey_response)
        Notification.count.should == 0
      end
    end
  end

  describe "with PetitionSignature" do
    describe "signed_petition_on_followed_conversation_notification" do
      it "should create multiple records on followers of conversation" do
        given_petition_signature_with_conversation_and_subscriptions
        Notification.signed_petition_on_followed_conversation_notification(@petition_signature)
        Notification.count.should == 2
      end
      it "should send to the correct receivers" do
        given_petition_signature_with_conversation_and_subscriptions
        Notification.signed_petition_on_followed_conversation_notification(@petition_signature)
        (Notification.all.collect(&:receiver_id) - @conversation.subscriptions.collect(&:person_id)).should == []
      end
    end

    describe "signed_on_created_petition_notification" do
      it "should create multiple records on followers of conversation" do
        given_3_petition_signatures
        Notification.signed_on_created_petition_notification(@petition_signature)
        Notification.count.should == 1
      end
      it "should send to the correct receiver" do
        given_3_petition_signatures
        Notification.signed_on_created_petition_notification(@petition_signature)
        Notification.last.receiver_id = @petition.person_id
      end
    end
    describe "signed_on_signed_petition_notification" do
      it "should create multiple records on followers of conversation" do
        given_3_petition_signatures
        Notification.signed_on_signed_petition_notification(@petition_signature)
        Notification.count.should == 3
      end
      it "should send to the correct receivers" do
        given_3_petition_signatures
        Notification.signed_on_signed_petition_notification(@petition_signature)
        (Notification.all.collect(&:receiver_id) - @petition.signer_ids).should == []
      end
    end
    describe "destroy_signed_petition_on_followed_conversation_notification" do
      it "should destroy the notification record" do
        given_petition_signature_with_conversation_and_subscriptions
        Notification.signed_petition_on_followed_conversation_notification(@petition_signature)
        Notification.count.should == 2
        Notification.destroy_signed_petition_on_followed_conversation_notification(@petition_signature)
        Notification.count.should == 0
      end
    end
    describe "destroy_signed_on_created_petition_notification" do
      it "should destroy the notification record" do
        given_petition_signature_with_conversation_and_subscriptions
        Notification.signed_on_created_petition_notification(@petition_signature)
        Notification.count.should == 1
        Notification.destroy_signed_on_created_petition_notification(@petition_signature)
        Notification.count.should == 0
      end
    end
    describe "destroy_signed_on_signed_petition_notification" do
      it "should destroy the notification record" do
        given_3_petition_signatures
        Notification.signed_on_signed_petition_notification(@petition_signature)
        Notification.count.should == 3
        Notification.destroy_signed_on_signed_petition_notification(@petition_signature)
        Notification.count.should == 0
      end
    end
  end

  describe "with Reflection" do
    describe "reflected_on_followed_conversation_notification" do
      it "should create multiple records on followers of conversation" do
        given_reflection_with_conversation_and_subscriptions
        Notification.reflected_on_followed_conversation_notification(@reflection)
        Notification.count.should == 2
      end
      it "should send to the correct receivers" do
        given_reflection_with_conversation_and_subscriptions
        Notification.reflected_on_followed_conversation_notification(@reflection)
        (Notification.all.collect(&:receiver_id) - @conversation.subscriptions.collect(&:person_id)).should == []
      end
    end

    describe "destroy_reflected_on_followed_conversation_notification" do
      it "should destroy the notification record" do
        given_reflection_with_conversation_and_subscriptions
        Notification.reflected_on_followed_conversation_notification(@reflection)
        Notification.count.should == 2
        Notification.destroy_reflected_on_followed_conversation_notification(@reflection)
        Notification.count.should == 0
      end
    end
  end

  describe "with ReflectionComment" do
    describe "commented_on_created_reflection_notification" do
      it "should create the notification record" do
        given_reflection_comment_with_reflection
        Notification.count.should == 0
        Notification.commented_on_created_reflection_notification(@reflection_comment)
        Notification.count.should == 1
      end
      it "should set the correct person_id" do
        given_reflection_comment_with_reflection
        Notification.commented_on_created_reflection_notification(@reflection_comment)
        Notification.last.person_id.should == @reflection_comment.person_id
      end
      it "should set correct receiver_id" do
        given_reflection_comment_with_reflection
        Notification.commented_on_created_reflection_notification(@reflection_comment)
        Notification.last.receiver_id.should == @reflection_comment.reflection.owner
      end
    end

    describe "commented_on_commented_reflection_notification" do
      it "should create multiple records on followers of conversation" do
        given_3_reflection_comments
        Notification.commented_on_commented_reflection_notification(@reflection_comment)
        Notification.count.should == 2
      end
      it "should send to the correct receivers" do
        given_3_reflection_comments
        Notification.commented_on_commented_reflection_notification(@reflection_comment)
        (Notification.all.collect(&:receiver_id) - @reflection_comment.reflection.commenter_ids).should == []
      end
    end

    describe "destroy_commented_on_created_reflection_notification" do
      it "should destroy the notification record" do
        given_reflection_comment_with_reflection
        Notification.commented_on_created_reflection_notification(@reflection_comment)
        Notification.count.should == 1
        Notification.destroy_commented_on_created_reflection_notification(@reflection_comment)
        Notification.count.should == 0
      end
    end

    describe "destroy_commented_on_created_reflection_notification" do
      it "should destroy the notification record" do
        given_3_reflection_comments
        Notification.commented_on_commented_reflection_notification(@reflection_comment)
        Notification.count.should == 2
        Notification.destroy_commented_on_commented_reflection_notification(@reflection_comment)
        Notification.count.should == 0
      end
    end

  end

  describe "create_for" do
    context "on Contribution" do
      it "should call the contributed_on_created_conversation_notification method" do
        given_a_contribution_with_conversation
        Notification.should_receive(:contributed_on_created_conversation_notification)
        Notification.create_for(@contribution)
      end
      it "should call the contributed_on_contribution_notification method" do
        given_a_contribution_with_conversation
        Notification.should_receive(:contributed_on_contribution_notification)
        Notification.create_for(@contribution)
      end
      it "should call the contributed_on_followed_conversation_notification method" do
        given_a_contribution_with_conversation
        Notification.should_receive(:contributed_on_followed_conversation_notification)
        Notification.create_for(@contribution)
      end
    end
    context "on RatingGroup" do
      it "should call the rated_on_contribution_notification method" do
        given_rating_group_with_contribution_with_conversation_and_subscriptions
        Notification.should_receive(:rated_on_contribution_notification)
        Notification.create_for(@rating_group)
      end

      it "should call the rated_on_followed_conversation_notification method" do
        given_rating_group_with_contribution_with_conversation_and_subscriptions
        Notification.should_receive(:rated_on_followed_conversation_notification)
        Notification.create_for(@rating_group)
      end
    end
    context "on SurveyResponse" do
      it "should call the voted_on_followed_conversation_notification method" do
        given_survey_response_with_conversation_and_subscriptions
        Notification.should_receive(:voted_on_followed_conversation_notification)
        Notification.create_for(@survey_response)
      end
      it "should call the voted_on_created_vote_notification method" do
        given_survey_response_with_conversation_and_subscriptions
        Notification.should_receive(:voted_on_created_vote_notification)
        Notification.create_for(@survey_response)
      end
      it "should call the voted_on_voted_vote_notification method" do
        given_survey_response_with_conversation_and_subscriptions
        Notification.should_receive(:voted_on_voted_vote_notification)
        Notification.create_for(@survey_response)
      end
    end
    context "on PetitionSignature" do
      it "should call the signed_petition_on_followed_conversation_notification method" do
        given_petition_signature_with_conversation_and_subscriptions
        Notification.should_receive(:signed_petition_on_followed_conversation_notification)
        Notification.create_for(@petition_signature)
      end
      it "should call the signed_on_created_petition_notification method" do
        given_petition_signature_with_conversation_and_subscriptions
        Notification.should_receive(:signed_on_created_petition_notification)
        Notification.create_for(@petition_signature)
      end
      it "should call the signed_on_signed_petition_notification method" do
        given_petition_signature_with_conversation_and_subscriptions
        Notification.should_receive(:signed_on_signed_petition_notification)
        Notification.create_for(@petition_signature)
      end
    end
    context "on Reflection" do
      it "should call the reflected_on_followed_conversation_notification method" do
        given_reflection_with_conversation_and_subscriptions
        Notification.should_receive(:reflected_on_followed_conversation_notification)
        Notification.create_for(@reflection)
      end
    end
    context "on ReflectionComment" do
      it "should call the commented_on_created_reflection_notification method" do
        given_reflection_comment_with_reflection
        Notification.should_receive(:commented_on_created_reflection_notification)
        Notification.create_for(@reflection_comment)
      end
      it "should call the commented_on_commented_reflection_notification method" do
        given_reflection_comment_with_reflection
        Notification.should_receive(:commented_on_commented_reflection_notification)
        Notification.create_for(@reflection_comment)
      end
    end
  end

  describe "destroy_for" do
    context "on Contribution" do
      it "should call the contributed_on_created_conversation_notification method" do
        given_a_contribution_with_conversation
        Notification.should_receive(:destroy_contributed_on_created_conversation_notification)
        Notification.destroy_for(@contribution)
      end
      it "should call the destroy_contributed_on_contribution_notification method" do
        given_a_contribution_with_conversation
        Notification.should_receive(:destroy_contributed_on_contribution_notification)
        Notification.destroy_for(@contribution)
      end
      it "should call the destroy_contributed_on_followed_conversation_notification method" do
        given_a_contribution_with_conversation
        Notification.should_receive(:destroy_contributed_on_followed_conversation_notification)
        Notification.destroy_for(@contribution)
      end
    end
    context "on RatingGroup" do
      it "should call the destroy_rated_on_contribution_notification method" do
        given_rating_group_with_contribution_with_conversation_and_subscriptions
        Notification.should_receive(:destroy_rated_on_contribution_notification)
        Notification.destroy_for(@rating_group)
      end
      it "should call the destroy_rated_on_followed_conversation_notification method" do
        given_rating_group_with_contribution_with_conversation_and_subscriptions
        Notification.should_receive(:destroy_rated_on_followed_conversation_notification)
        Notification.destroy_for(@rating_group)
      end
    end
    context "on SurveyResponse" do
      it "should call the destroy_rated_on_followed_conversation_notification method" do
        given_survey_response_with_conversation_and_subscriptions
        Notification.should_receive(:destroy_voted_on_followed_conversation_notification)
        Notification.destroy_for(@survey_response)
      end
      it "should call the destroy_voted_on_created_vote_notification method" do
        given_survey_response_with_conversation_and_subscriptions
        Notification.should_receive(:destroy_voted_on_created_vote_notification)
        Notification.destroy_for(@survey_response)
      end
      it "should call the destroy_voted_on_vote_vote_notification method" do
        given_survey_response_with_conversation_and_subscriptions
        Notification.should_receive(:destroy_voted_on_voted_vote_notification)
        Notification.destroy_for(@survey_response)
      end
    end
    context "on PetitionSignature" do
      it "should call the destroy_signed_petition_on_followed_conversation_notification method" do
        given_petition_signature_with_conversation_and_subscriptions
        Notification.should_receive(:destroy_signed_petition_on_followed_conversation_notification)
        Notification.destroy_for(@petition_signature)
      end
      it "should call the destroy_signed_on_created_petition_notification method" do
        given_petition_signature_with_conversation_and_subscriptions
        Notification.should_receive(:destroy_signed_on_created_petition_notification)
        Notification.destroy_for(@petition_signature)
      end
      it "should call the destroy_signed_on_signed_petition_notification method" do
        given_petition_signature_with_conversation_and_subscriptions
        Notification.should_receive(:destroy_signed_on_signed_petition_notification)
        Notification.destroy_for(@petition_signature)
      end

    end
    context "on Reflection" do
      it "should call the destroy_reflected_on_followed_conversation_notification method" do
        given_reflection_with_conversation_and_subscriptions
        Notification.should_receive(:destroy_reflected_on_followed_conversation_notification)
        Notification.destroy_for(@reflection)
      end
    end
    context "on ReflectionComment" do
      it "should call the destroy_commented_on_created_reflection_notification method" do
        given_reflection_comment_with_reflection
        Notification.should_receive(:destroy_commented_on_created_reflection_notification)
        Notification.destroy_for(@reflection_comment)
      end
      it "should call the destroy_commented_on_commented_reflection_notification method" do
        given_reflection_comment_with_reflection
        Notification.should_receive(:destroy_commented_on_commented_reflection_notification)
        Notification.destroy_for(@reflection_comment)
      end
    end

    describe "users_with_notifications" do
      it "returns the number of users notified" do
        p = FactoryGirl.create(:registered_user)
        @notification1 = FactoryGirl.create(:notification, :person => p, :created_at => Time.now)
        @notification2 = FactoryGirl.create(:notification, :person => p, :created_at => 1.day.ago)
        @notification3 = FactoryGirl.create(:notification, :created_at => 2.days.ago)

        Notification.count.should == 3
        Notification.users_with_notifications.count.should == 2
      end
    end

    describe "limit_notifications_per_user" do
      it "will reduce notifications in the system" do
        p = FactoryGirl.create(:registered_user)
        @notification1 = FactoryGirl.create(:notification, :person => p, :created_at => Time.now)
        @notification2 = FactoryGirl.create(:notification, :person => p, :created_at => 1.day.ago)
        @notification3 = FactoryGirl.create(:notification, :person => p, :created_at => 2.days.ago)

        Notification.count.should == 3
        Notification.users_with_notifications.count.should == 1
        Notification.limit_notifications_per_user(:limit => 2).should == [@notifications1, @notifications2]
      end
    end
  end
end
