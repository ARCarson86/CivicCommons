require 'spec_helper'

describe NotificationObserver do

  before :all do
    ActiveRecord::Observer.enable_observers
  end

  after :all do
    ActiveRecord::Observer.disable_observers
  end

  context "After create" do
    context "if a model is not a contribution and not unconfirmed" do
      it "should call the Notification.create_for(model) method" do
        Notification.should_receive(:create_for).once
        FactoryGirl.create(:conversation)
      end
    end
    context "if a model is a contribution and is unconfirmed" do
      it "should not do anything" do
        conversation = FactoryGirl.create(:conversation)
        Notification.should_not_receive(:create_for)
        FactoryGirl.create(:contribution, :confirmed => false, :conversation => conversation)
      end
    end
  end
  
  context "Before Update" do
    context "if a model is a Contribution, and it has just changed to confirmed" do
      it "should call the Notification.create_for(model) method" do
        conversation = FactoryGirl.create(:conversation)
        contribution = FactoryGirl.create(:contribution, :confirmed => false, :conversation => conversation)
        Notification.should_receive(:create_for).once
        contribution.confirmed = true
        contribution.save
      end
    end
    context "if a model is not a Contribution" do
      it "should not do anything" do
        conversation = FactoryGirl.create(:conversation)
        conversation.created_at = 'changed summary'
        Notification.should_not_receive(:create_for)
        conversation.save
      end
    end
  end

  context "Before Destroy" do
    it "should call the Notification.destroy_for(model) method" do
      contribution = FactoryGirl.create(:contribution)
      Notification.should_receive(:destroy_for).once
      contribution.destroy
    end
  end  
end
