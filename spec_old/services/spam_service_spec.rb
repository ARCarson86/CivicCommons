require 'spec_helper'

describe SpamService do
  context "spam?" do
    describe "if there are restrictions" do
      before(:each) do
        @restriction1 = FactoryGirl.create(:email_restriction,:domain => 'yeah.net')
        @restriction2 = FactoryGirl.create(:email_restriction,:domain => '163.com')
        @restriction3 = FactoryGirl.create(:email_restriction,:domain => '21cn.com')
      end
      it "should reject spam emails" do
        SpamService.spam?('spammer@yeah.net').should == true
        SpamService.spam?('spammer@163.com').should == true
        SpamService.spam?('spammer@21cn.com').should == true
      end
      it "should reject spam emails with case insesitivity" do
        SpamService.spam?('imspammer@YeAh.net').should == true
      end
      it "should allow non-spam emails" do
        SpamService.spam?('jon@nospam.com').should == false
      end
    end
    describe "if there are no restrictions" do
      it "should not reject spam emails" do
        SpamService.spam?('spammer@yeah.net').should_not == true
        SpamService.spam?('spammer@163.com').should_not == true
        SpamService.spam?('spammer@21cn.com').should_not == true
      end
    end
  end
end
