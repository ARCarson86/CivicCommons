require 'spec_helper'

describe BlogController do
  
  def stub_radioshow(attributes = {})
    @radio_show ||= stub_model(ContentItem, attributes.merge({:content_type => 'RadioShow'})).as_null_object
  end
  def stub_blogpost(attributes = {})
    @blog_post ||= stub_model(ContentItem, attributes.merge({:content_type => 'BlogPost'})).as_null_object
  end
  def stub_topic(attributes = {})
    @topic ||= stub_model(Topic, attributes).as_null_object
  end
  
  describe "index" do
    before(:each) do
      ContentItem.stub!(:blog_authors)
    end
    it "should fetch all blog authors" do
      ContentItem.should_receive(:blog_authors)
      get :index
    end
    it "should fetch topics" do
      Topic.should_receive(:including_public_blogposts)
      get :index
    end
    it "should fetch current topic" do
      Topic.should_receive(:find_by_id).with("123")
      get :index, :topic => 123
    end
    context "blog posts" do
      it "should fetch all blogposts" do
        Topic.stub(:find_by_id).and_return(nil)
        ContentItem.should_receive(:blog_post).and_return(stub_topic)
        stub_topic.should_receive(:recent_blog_posts).and_return(stub_topic)
        stub_topic.should_receive(:paginate).and_return(stub_topic)
        get :index
      end
      it "should fetch a topic's blogposts if there is a current topic" do
        Topic.stub(:find_by_id).and_return(stub_topic)
        stub_topic.should_receive(:blogposts).and_return(stub_topic)
        stub_topic.should_receive(:recent_blog_posts).and_return(stub_topic)
        stub_topic.should_receive(:paginate).and_return(stub_topic)
        get :index, :topic => 123
      end
    end
    context "current author" do
      it "should get current_author if params[:author_id] exists" do
        Person.should_receive(:find).with("123")
        get :index, :author_id => 123
      end
      it "should NOT get current_author if params[:author_id] doesn't exists" do
        Person.should_not_receive(:find).with("123")
        get :index
      end
    end 
  end

end
