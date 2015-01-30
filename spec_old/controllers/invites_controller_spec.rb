require 'spec_helper'

describe InvitesController do

  before(:each) do
    @admin = FactoryGirl.create(:admin_person)
    @conversation = FactoryGirl.create(:conversation)
    controller.stub!(:current_person).and_return(@admin)
    @person = FactoryGirl.create(:normal_person)
    @invite = stub_model(Invite).as_null_object
    Invite.stub!(:new).and_return(@invite)
  end

  context "new" do
    it "sets the source type, source id and user for the new form page" do
      @invite.should_receive(:source_type=).with('conversations')
      @invite.should_receive(:source_id=).with(@conversation.id.to_s)
      @invite.should_receive(:user=).with(@admin)

      get :new, source_type: 'conversations', source_id: @conversation.id
    end

    context "XHR" do
      it "renders a parital for XHR request" do
        xhr :get, :new, source_type: 'conversations', source_id: @conversation.id
        response.should render_template('invites/new')
        should respond_with_content_type(:js)
      end
    end

    context "not XHR" do
      it "renders regular layout" do
        get :new, source_type: 'conversations', source_id: @conversation.id
        response.should render_template('layouts/application')
        should respond_with_content_type(:html)
      end
    end
  end

  context "create" do
    it "sets the source type, source id and conversation for the create page and then send off email for a valid email." do
      @invite.should_receive(:valid?).and_return(true)
      @invite.should_receive(:user=).with(@admin)
      @invite.should_receive(:send_invites).and_return(true)
      @invite.stub!(:source_type).and_return('conversations')
      @invite.stub!(:source_id).and_return(123)
      put :create, source_type: 'conversations', source_id: @conversation.id, :invites => {emails: 'someemail@example.com'}

      # assigns(:source_type).should == 'conversations'
      # assigns(:source_id).should == @conversation.id
      # assigns(:conversation).should == @conversation
      assigns(:notice).should == "Thank you! You're helping to make your community stronger!"
    end

    it "sets an error message when email is too short" do
      @invite.should_receive(:valid?).and_return(false)
      put :create, source_type: 'conversations', source_id: @conversation.id, :invites => {emails: 's@e.c'}
      assigns(:error).should == "There was a problem with this form: "
    end
  end

end
