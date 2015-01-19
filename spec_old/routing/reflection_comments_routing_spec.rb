require "spec_helper"

describe ReflectionCommentsController do
  describe "routing" do

    it "recognizes and generates #edit" do
      { :get => "/conversations/1/reflections/123/comments/1234/edit" }.should route_to(:controller => "reflection_comments", :conversation_id => '1', :reflection_id => '123', :action => "edit", :id => '1234')
    end
    
    it "recognizes and generates #update" do
      { :put => "/conversations/1/reflections/123/comments/1234" }.should route_to(:controller => "reflection_comments", :conversation_id => '1', :reflection_id => '123', :action => "update", :id => '1234')
    end
    
    it "recognizes and generates #destroy" do
      { :delete => "/conversations/1/reflections/123/comments/1234" }.should route_to(:controller => "reflection_comments", :conversation_id => '1', :reflection_id => '123', :action => "destroy", :id => '1234')
    end

    it "recognizes and generates #create" do
      { :post => "/conversations/1/reflections/123/comments" }.should route_to(:controller => "reflection_comments", :conversation_id => '1', :reflection_id => '123', :action => "create")
    end

  end
end
