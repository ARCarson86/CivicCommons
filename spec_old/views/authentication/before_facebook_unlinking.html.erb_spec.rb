require 'spec_helper'
require 'devise/test_helpers'

describe '/authentication/before_facebook_unlinking.html.erb' do

  before(:each) do
    @person = stub_model(Person,
      :email => 'johnd@test.com'
    )
    @view.stub(:current_person).and_return(@person)
    render
  end

  it "should render the form with zipcode" do
    class SecureUrlHelperClass
      include SecureUrlHelper
            
      def default_url_options
        @default_url_options ||= {:host => 'test.host'}
      end
    end
    secureUrlHelper = SecureUrlHelperClass.new
    content_for(:main_body).should have_selector("form", :action => process_facebook_unlinking_path, :method => "post", "data-remote" => 'true', :id => 'ajax-before-facebook-unlinking-form', 'data-type'=>"html" ) do |form|
      form.should have_selector("input#person_email")
      form.should have_selector("input#person_password")
      form.should have_selector("input#person_password_confirmation")
      form.should have_selector("input.submit")
      form.should have_selector("a.cancel", :href => secureUrlHelper.secure_edit_user_url(@person))
    end
  end
end
