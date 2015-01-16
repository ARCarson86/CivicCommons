require 'spec_helper'
describe '/conversations/new.html.erb' do

  before(:each) do
    @conversation = Conversation.new
  end

  it "should show a default Conversation zipcode of 'ALL'" do
    render
    rendered.include?('<input id="conversation_zip_code" name="conversation[zip_code]" type="hidden" value="ALL" />').should be_true
  end

end
