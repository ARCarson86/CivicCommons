require 'spec_helper'

describe 'notifier/email_changed.html.erb' do
  def stubs
    @new_email = 'new-email@example.com'
    @old_email = 'old-email@example.com'
  end
  
  before(:each) do
    stubs
  end
  
  it "should display new_email" do
    render
    rendered.should contain 'new-email@example.com'
  end

  it "should display old_email" do
    render
    rendered.should contain 'old-email@example.com'
  end

  it "should display the correct mailto link" do
    Civiccommons::Config.should_receive(:email).and_return({"default_email"=>"myemail@example.com", "support_email"=>"support@example.com"})
    render
    rendered.should have_selector('a',:href => 'mailto:support@example.com?subject=Email%20Violation%20Alert')
  end

end
