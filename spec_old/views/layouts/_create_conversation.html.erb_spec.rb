require 'spec_helper'

describe 'layouts/_create_conversation.html.erb' do
  
  before(:each) do
    render
  end

  it "should include verbiage about starting a conversation" do
    rendered.should =~ /start[\w\s]*conversation/i
  end

  it "should include a link to start a conversation" do
    assert_select "a", :href => new_conversation_path, :text => /conversation/i
  end

end
