require 'spec_helper'

describe Admin::ConversationsHelper do

  describe "toggle_staff_pick_link" do

    it "returns a link with the class of 'on' when conversation is staff picked" do
      conversation = FactoryGirl.create(:conversation, staff_pick: true)
      helper.toggle_staff_pick_link(conversation).should include('on')
    end

    it "returns a link with the class of 'off' when the conversation is not a staff pick" do
      conversation = FactoryGirl.create(:conversation, staff_pick: false)
      helper.toggle_staff_pick_link(conversation).should include('off')
    end

  end

end
