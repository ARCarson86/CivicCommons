#passed
require 'spec_helper'

describe Invite do
  def given_an_invite
    @invite = FactoryGirl.build(:invite)
  end
  describe "validation" do
    def given_an_invalid_invite
      @invite = Invite.new
      @invite.valid?
      return @invite
    end
    it "should validate presence of emails" do
      given_an_invalid_invite
      @invite.errors[:emails].first.should == "can't be blank"
    end
    it "should validate presence of source_type" do
      given_an_invalid_invite
      @invite.errors[:source_type].first.should == "can't be blank"
    end
    it "should validate presence of source_id" do
      given_an_invalid_invite
      @invite.errors[:source_id].first.should == "can't be blank"
    end
    it "should validate presence of user" do
      given_an_invalid_invite
      @invite.errors[:user].first.should == "can't be blank"
    end
    describe "validates_format_of :emails" do
      def given_an_invite_with_email(emails='')
        @invite = FactoryGirl.build(:invite,:emails=>emails)
        @invite.valid?
      end
      it "should validate on correctness of email format" do
        given_an_invite_with_email('abc@test,com')
        @invite.errors[:emails].first.should == "must be in the correct format, example: abc@test.com"
      end
      it "should disallow test@test@test.com" do
        given_an_invite_with_email('test@test@test.com')
        @invite.errors[:emails].first.should == "must be in the correct format, example: abc@test.com"
      end
      it "should disallow test@test@test.com" do
        given_an_invite_with_email('test@test@test.com')
        @invite.errors[:emails].first.should == "must be in the correct format, example: abc@test.com"
      end
      it "should allow multiple emails separated by space or comma" do
        given_an_invite_with_email('abc@test.com, ccc@test.com ')
        @invite.errors[:emails].should be_empty
      end
    end
  end

  describe "#conversation" do
    def given_an_invite_with_valid_conversation
      @conversation = FactoryGirl.create(:conversation)
      @invite = FactoryGirl.build(:invite, :source_id=>@conversation.id, :source_type=>'conversations')
    end
    it "should find the conversation based on the source_id" do
      given_an_invite_with_valid_conversation
      @invite.conversation.should == @conversation
    end
    it "should default to the first conversation when there is no source_id found" do
      @conversation1 = FactoryGirl.create(:conversation)
      @conversation2 = FactoryGirl.create(:conversation)
      @invite = FactoryGirl.build(:invite, :source_id=>123456, :source_type=>'conversations')
      @invite.conversation.should == @conversation1
    end
  end

  describe "send_invites" do
    context "if valid" do
      it "should send send_conversation_invites if source_type is a conversation" do
        given_an_invite
        @invite.should_receive(:send_conversation_invites)
        @invite.send_invites
      end
    end
    context "if not valid" do
      it "should not send anything and return false" do
        @invite = Invite.new
        @invite.send_invites.should be_false
      end
    end
  end
  
  describe "splitted_emails" do
    it "should split the emails based on new line or comma" do
      emails="first@test.com second@test.com, third@test.com \nfourth@test.com"
      @invite = FactoryGirl.build(:invite, :emails=>emails)
      @invite.splitted_emails.should == ['first@test.com', 'second@test.com', 'third@test.com', 'fourth@test.com']
    end
  end

  describe "parsed_email" do
    let(:valid_results) {['alpha@example.com', 'bravo@example.com', 'charlie@example.com']}
    def given_invite_with_emails(emails="")
      @invite = FactoryGirl.build(:invite, :emails=>emails)
    end
    it "should correctly parse and return an array of emails" do
      given_invite_with_emails("alpha@example.com, bravo@example.com\n charlie@example.com")
      @invite.parsed_emails.should == valid_results
    end

    it "should parse emails delimited by commas" do
      emails = "alpha@example.com, bravo@example.com, charlie@example.com"
      given_invite_with_emails(emails)
      @invite.parsed_emails.should == valid_results
    end

    it "should parse emails delimited by lines" do
      emails = "alpha@example.com\r\n bravo@example.com\r\ncharlie@example.com"
      given_invite_with_emails(emails)
      @invite.parsed_emails.should == valid_results

      emails = "alpha@example.com\nbravo@example.com\ncharlie@example.com"
      given_invite_with_emails(emails)
      @invite.parsed_emails.should == valid_results

      emails = "alpha@example.com\rbravo@example.com\rcharlie@example.com"
      given_invite_with_emails(emails)
      @invite.parsed_emails.should == valid_results
    end
    it "should parse emails with space in between them" do
      emails = 'alpha@example.com bravo@example.com charlie@example.com'
      given_invite_with_emails(emails)
      @invite.parsed_emails.should == valid_results
    end
  end

  describe "send_invites" do
    it "should not escape the html of the summary" do
      summary = '<em>Strong Tag Here</em>'
      conversation = FactoryGirl.create(:conversation,:summary=> summary)
      user = FactoryGirl.create(:registered_user)
      @invite = FactoryGirl.build(:invite,:user => user, :source_id=>conversation.id, :source_type=> 'conversations')
      @invite.send_invites
      ActionMailer::Base.deliveries.last.body.include?(summary).should be_true
    end
    
  end
end
