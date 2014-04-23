#passed
require 'spec_helper'

describe Tos do

  before(:each) do
    @user = FactoryGirl.create(:registered_user, :name => 'Whistle Blower', :daily_digest => true, :avatar => nil)
    @contribution = FactoryGirl.create(:comment, :content => 'spam spam spam')
    @reason = "This comment is spam."
  end

  it "sends a violation complaint" do
    Notifier.deliveries  = []
    email = Tos.send_violation_complaint(@user, @contribution, @reason)

    Notifier.deliveries.length.should == 1

    email.subject.should == "ALERT: Possible TOS Violation reported"
    email[:from].to_s.should == Devise.mailer_sender
    email.to.should == [Civiccommons::Config.email["default_email"]]

    email.should have_body_text(/Whistle Blower/)
    email.should have_body_text(/This comment is spam\./)
    email.should have_body_text(/spam spam spam/)
  end

end
