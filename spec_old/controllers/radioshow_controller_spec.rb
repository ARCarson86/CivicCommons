require 'spec_helper'

describe RadioshowController do
  def stub_radioshow(attributes = {})
    @radio_show ||= stub_model(ContentItem, attributes.merge({:content_type => 'RadioShow'})).as_null_object
  end
  def stub_blogpost(attributes = {})
    @radio_show ||= stub_model(ContentItem, attributes.merge({:content_type => 'BlogPost'})).as_null_object
  end
  
  describe "index" do
    before(:each) do
      ContentItem.stub_chain(:where,:order,:paginate).and_return([stub_radioshow])
      ContentItem.stub_chain(:recent_blog_posts,:limit).and_return(stub_blogpost)
    end
    
    it "should fetch the latest blog posts" do
      ContentItem.should_receive(:recent_blog_posts)
      get :index
    end
  end

end
