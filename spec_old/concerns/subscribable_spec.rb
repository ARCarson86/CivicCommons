require 'spec_helper'

[Conversation, Issue, Organization].each do |model_type|
  describe model_type.to_s do
    let(:item) {FactoryGirl.create(model_type.to_s.downcase)}

    before(:each) do
      @person = FactoryGirl.create(:normal_person)
    end

    context "is subscribed to a by the current user" do
      it "adds a subscription to the #{model_type.to_s} for the current user" do
        subscription = item.subscribe(@person)

        subscription.class.should == Subscription
        subscription.person.should == @person
        subscription.subscribable_type == model_type.to_s
      end
    end

    context 'is unsubscribed to by the current user' do
      it "should remove a subscription to the #{model_type.to_s} for the current user" do
        subscription = item.subscribe(@person)
        item.unsubscribe(@person)
        @person.subscriptions.blank?.should be_true
      end
    end

    context "subscribers" do
      it "returns an array with a person after they follow a #{model_type.to_s}" do
        item.subscribe(@person)
        item.subscribers.include?(@person).should be_true
      end
      it "returns an unordered array of people following a #{model_type.to_s}" do
        person2 = FactoryGirl.create(:normal_person)
        item.subscribe(@person)
        item.subscribe(person2)
        item.subscribers.include?(@person).should be_true
        item.subscribers.include?(person2).should be_true
      end
      it "returns an empty array if no one is following." do
        # Conversations start with one follower, the creator
        if model_type == Conversation
          item.subscribers.size.should == 1
        else
          item.subscribers.size.should == 0
        end
      end
    end
  end
end
