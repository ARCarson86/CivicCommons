require "spec_helper"

describe PetitionsController do
  describe "routing" do
    it "recognizes and generates #new" do
      { get: "/conversations/123/petitions/new" }.should route_to(controller: "petitions", action: "new", :conversation_id => '123')
    end
    
    it "recognizes and generates #edit" do
      { get: "/conversations/123/petitions/1234/edit" }.should route_to(controller: "petitions", action: "edit", :conversation_id => '123', :id => '1234')
    end
    
    it "recognizes and generates #update" do
      { put: "/conversations/123/petitions/1234" }.should route_to(controller: "petitions", action: "update", :conversation_id => '123', :id => '1234')
    end
    
    it "recognizes and generates #destroy" do
      { delete: "/conversations/123/petitions/1234" }.should route_to(controller: "petitions", action: "destroy", :conversation_id => '123', :id => '1234')
    end

    it "recognizes and generates #create" do
      { post: "/conversations/123/petitions" }.should route_to(controller: "petitions", action: "create", :conversation_id => '123')
    end

    it "recognizes and generates #show" do
      { get: "/conversations/123/petitions/1234" }.should route_to(controller: "petitions", action: "show", :conversation_id => '123', :id => '1234')
    end

    it "recognizes and generates #sign" do
      { post: "/conversations/123/petitions/1234/sign" }.should route_to(controller: "petitions", action: "sign", :conversation_id => '123', :id => '1234')
    end

    it "recognizes and generates #sign_modal" do
      { get: "/conversations/123/petitions/1234/sign" }.should route_to(controller: "petitions", action: "sign_modal", :conversation_id => '123', :id => '1234')
    end
    
  end

end
