require 'spec_helper'

describe WidgetsController do

  def mock_conversation(stubs={})
    @mock_conversation ||= mock_model(Conversation, stubs).as_null_object
  end
  
  def mock_content_item(stubs={})
    @mock_content_item ||= mock_model(ContentItem, stubs).as_null_object
  end
  
  def mock_activity(stubs={})
    @mock_activity ||= mock_model(Activity, stubs).as_null_object
  end

  describe "cc_widget" do
    it "should render template widget.js" do
      get :cc_widget, :format => :js
      response.should render_template 'widgets/cc_widget'
    end
    it "should set the @data_source" do
      get :cc_widget, :src => '/data-source-path'
      assigns(:data_source).should == '/data-source-path'
    end
    it "should set the @dom" do
      get :cc_widget, :dom => 'dom-id-here'
      assigns(:dom_id).should == 'dom-id-here'
    end
  end
end
