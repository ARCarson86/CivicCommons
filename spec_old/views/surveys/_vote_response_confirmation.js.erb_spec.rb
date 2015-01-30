require 'spec_helper'

describe '/surveys/_vote_response_confirmation.js.erb' do
  
  before(:each) do
    @template_page = 'rendering _vote_response_confirmation.html.erb'
    stub_template('/surveys/_vote_response_confirmation.html.erb' => @template_page)
    render
  end

  it "should display the colorbox" do
    pending "This works when testing manually, need to revisit again on how to test partial the problem with stub_template"
    rendered.should contain '$.colorbox'
  end

  it "should render the _vote_response_confirmation.html.erb" do
    rendered.should contain @template_page
  end

end
