require 'spec_helper'

describe ReflectionCommentsController do

  def mock_conversation(stubs={})
    @mock_conversation ||= mock_model(Conversation, stubs).as_null_object
  end

  def mock_reflection(stubs={})
    @mock_reflection ||= mock_model(Reflection, stubs).as_null_object
  end

  def mock_reflection_comment(stubs={})
    @mock_reflection_comment ||= mock_model(ReflectionComment, stubs).as_null_object
  end
  

  def stub_person(stubs={:id => 111})
    @stub_person ||= stub_model(Person, stubs).as_null_object
  end

  before(:each) do
    @controller.stub!(:require_user).and_return(true)
    @controller.stub!(:current_person).and_return(stub_person)
    Conversation.stub(:find).with("7") { mock_conversation }
    mock_conversation.stub_chain(:reflections,:find).and_return(mock_reflection)
    mock_reflection.stub_chain(:comments,:find).and_return(mock_reflection_comment)
  end

  describe "GET edit" do
    before(:each) do
      @controller.stub!(:verify_moderating_ability).and_return(true)
    end
    it "should be successful" do
      get :edit, :conversation_id => 7, :reflection_id => 123, :id => 1234
      response.should be_success
    end
  end
  
  describe "PUT update" do
    before(:each) do
      @controller.stub!(:verify_moderating_ability).and_return(true)
    end
    it "should redirect to conversation comment reflection if successful" do
      mock_reflection_comment.should_receive(:update_attributes).with({'these' => 'params'}).and_return(true)
      put :update, :reflection_comment => {'these' => 'params'}, :conversation_id => 7, :reflection_id => 123, :id => 1234
      response.should redirect_to conversation_reflection_path(mock_conversation, mock_reflection)
    end
    it "should render the edit action if unsuccessful" do
      mock_reflection_comment.should_receive(:update_attributes).with({'these' => 'params'}).and_return(false)
      put :update, :reflection_comment => {'these' => 'params'}, :conversation_id => 7, :reflection_id => 123, :id => 1234
      response.should render_template :action => :edit
    end
    it "should set flash message if successful" do
      mock_reflection_comment.should_receive(:update_attributes).with({'these' => 'params'}).and_return(true)
      put :update, :reflection_comment => {'these' => 'params'}, :conversation_id => 7, :reflection_id => 123, :id => 1234
      flash[:notice].should == 'This comment has been successfully updated'
    end
  end
  
  describe "DELETE destroy" do
    before(:each) do
      @controller.stub!(:verify_moderating_ability).and_return(true)
    end
    it "should set flash message if successful" do
      mock_reflection_comment.should_receive(:destroy)
      delete :destroy, :conversation_id => 7, :reflection_id => 123, :id => 1234
      flash[:notice].should == 'This comment has been successfully deleted'
    end
    it "should redirect to conversation comment reflection" do
      mock_reflection_comment.should_receive(:destroy)
      delete :destroy, :conversation_id => 7, :reflection_id => 123, :id => 1234
      response.should redirect_to conversation_reflection_path(mock_conversation, mock_reflection)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "redirects to the reflection_path" do
        @mock_reflection.stub_chain(:comments, :build).with({'these' => 'params'}) { mock_reflection(:save => true) }
        post :create, :reflection_comment => {'these' => 'params'}, :conversation_id => 7, :reflection_id => 123
        response.should redirect_to(conversation_reflection_path(mock_conversation, mock_reflection))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved reflection as @reflection" do
        @mock_reflection.stub_chain(:comments, :build).with({'these' => 'params'}) { mock_reflection(:save => false) }
        post :create, :reflection_comment => {'these' => 'params'}, :conversation_id => 7, :reflection_id => 123
        assigns(:reflection).should be(mock_reflection)
      end

      it "re-renders the 'new' template" do
        @mock_reflection.stub_chain(:comments, :build).with({}) { mock_reflection(:save => false) }
        post :create, :reflection_comment => {}, :conversation_id => 7, :reflection_id => 123
        response.should render_template(:controller => [@conversation, @reflection], :action => "new") #render_template("new")
      end
    end
  end


end
