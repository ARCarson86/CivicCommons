require 'spec_helper'

describe Subscription do
  before(:each) do
    @normal_person = Factory.create(:normal_person)
  end
  
  it "should have a person and conversation" do
    subscription = Factory.build(:subscription)
    subscription.person.name.should == "Marc Canter"
    subscription.subscribable.title.should == 'Civic Commons'
  end
end
