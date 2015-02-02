#passed
require 'spec_helper'

describe Subscription do
  let(:user)         {FactoryGirl.create(:normal_person)}
  let(:conversation) {FactoryGirl.create(:conversation, title: 'How to improve Cleveland')}
  let(:issue)        {FactoryGirl.create(:issue, name: 'Issue Title')}
  let(:organization) {FactoryGirl.create(:organization, name: 'The Civic Commons')}

  context "for a conversation" do
    it 'will be created by calling subscribe' do
      subscription = Subscription.subscribe(conversation.class.to_s, conversation.id, user)
      subscription.subscribable.title.should == 'How to improve Cleveland'
    end

    it "has a person and conversation" do
      subscription = FactoryGirl.build(:conversation_subscription)
      subscription.person_name.should == "Marc Canter"
      subscription.subscribable_type.should == "Conversation"
      subscription.title.should == 'The Civic Commons'
    end
  end

  context "for an issue" do
    it 'will be created by calling subscribe' do
      subscription = Subscription.subscribe(issue.class.to_s, issue.id, user)
      subscription.subscribable_type.should == "Issue"
      subscription.subscribable.title.should == 'Issue Title'
    end

    it "has a person and issue" do
      subscription = FactoryGirl.build(:issue_subscription)
      subscription.person_name.should == "Marc Canter"
      subscription.subscribable.summary.should == 'The Civic Commons'
    end
  end

  context "for an organization" do
    it 'will be created by calling subscribe' do
      subscription = Subscription.subscribe(organization.class.to_s, organization.id, user)
      subscription.subscribable_type.should == "Organization"
      subscription.title.should == 'The Civic Commons'
    end

    it "has a person and issue" do
      subscription = FactoryGirl.build(:organization_subscription)
      subscription.person_name.should == "Marc Canter"
      subscription.title.should == 'The Civic Commons'
    end
  end

  describe "Subscription.create_unless_exists" do
    before(:each) do
      Subscription.create_unless_exists(user, conversation)
    end

    context "A person can only subscibe to an item one time" do
      it "creates a new subscription for the person when a subscription does not exist" do
        user.subscriptions.collect {|sub| sub.subscribable}.include?(conversation).should be_true
      end

      it "does not create a new subscription if the subscription already exists" do
        Subscription.create_unless_exists(user, conversation)
        user.subscriptions.length.should == 1
      end
    end
  end

end
