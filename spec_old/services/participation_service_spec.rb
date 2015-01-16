require 'spec_helper'

describe ParticipationService do
  describe 'participants_by_issue' do
    before(:each) do
      @issue = FactoryGirl.create(:issue)
      @convo1 = FactoryGirl.create(:conversation, :issues => [@issue])
      @convo2 = FactoryGirl.create(:user_generated_conversation, :issues => [@issue])
      @contrib = FactoryGirl.create(:contribution, :conversation => @convo2)
    end

    it "ignores issues with conversations without participants" do
      @issue.reload.conversations.should == [@convo1, @convo2]
      ps = ParticipationService.new

      # 1 - conversation owner
      # 1 - user generated converstation owner
      # 1 - conversation contributor
      ps.participants_by_issue(@issue.id).should == 3
    end
  end
end
