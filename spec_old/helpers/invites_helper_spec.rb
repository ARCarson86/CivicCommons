require 'spec_helper'

describe InvitesHelper do

  context "from_conversation_create_page?" do

    it "returns value in the params[:conversation_created]" do
      helper.params[:conversation_created] = true
      helper.from_conversation_create_page?.should be_true
    end

    it "returns nil if the params does not have the :conversation_created key" do
      helper.from_conversation_create_page?.should be_nil
    end

  end

end
