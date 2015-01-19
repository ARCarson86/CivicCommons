require 'spec_helper'

describe '/surveys/vote_successful.html.erb' do
  
  before(:each) do
    render
  end

  it "should display the title of the modal" do
    rendered.should have_selector('h2', :content => 'Thank you for voting!')
  end


end
