require 'spec_helper'
require 'devise/test_helpers'

describe '/authentication/fb_unlinking_success.html.erb' do
  
  
  before(:each) do
    @person = stub_model(Person,
      :email => 'johnd@test.com'
    )
    @view.stub(:current_person).and_return(@person)  
    render
  end
  
  it "should have the email" do
    content_for(:main_body).should contain('johnd@test.com')
  end
end
