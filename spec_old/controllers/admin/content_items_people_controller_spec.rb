require 'spec_helper'


describe Admin::ContentItemsPeopleController do

  def stub_content_item(attributes={})
    @content_item ||= stub_model(ContentItem,attributes).as_null_object
  end
  
  def stub_person(attributes={})
    @person ||= stub_model(Person, attributes).as_null_object
  end
  
  before(:each) do  
    @controller.stub(:verify_admin).and_return(true)
    @controller.stub(:current_person).and_return(stub_person(:admin => true))
    # sign_in FactoryGirl.create(:admin_person)
    ContentItem.stub!(:find).and_return(stub_content_item)
  end

  describe "GET index" do
    before(:each) do
      @content_item.stub!(:hosts).and_return([stub_person])
      @content_item.stub!(:guests).and_return([stub_person])
    end

    it "should get all hosts" do
      @content_item.should_receive(:hosts).and_return([stub_person])
      get :index, :content_item_id => 1
      assigns[:hosts].size.should == 1
    end
    
    it "should get all guests" do
      @content_item.should_receive(:guests).and_return([stub_person])
      get :index, :content_item_id => 1
      assigns[:guests].size.should == 1
    end
  end

  describe "GET new" do
    context "letter" do
      context "All" do
        before(:each) do
          get :new, :content_item_id => 1, :role => 'host', :letter => 'all'
        end
        it "should set the letter to 'all' " do
          assigns[:letter].should == 'all'
        end
        it "should set the queried_letter to nil" do
          assigns[:queried_letter].should be_nil
        end
      end
      context "alphabet" do
        before(:each) do
          get :new, :content_item_id => 1, :role => 'host', :letter => 'A'
        end
        it "should set the letter to 'A' " do
          assigns[:letter].should == 'A'
        end
        it "should set the queried_letter to nil" do
          assigns[:queried_letter].should == 'A'
        end
      end
      context "without any letter parameter" do
        before(:each) do
          get :new, :content_item_id => 1, :role => 'host'
        end
        it "should set the letter to 'A' " do
          assigns[:letter].should == 'A'
        end
        it "should set the queried_letter to nil" do
          assigns[:queried_letter].should == 'A'
        end
      end
    end
    it "should find person based on letter" do
      Person.should_receive(:find_confirmed_order_by_last_name).with('A').and_return(stub_person)
      get :new, :content_item_id => 1, :role => 'host', :letter => 'A'
    end
    it "should set the role based on params[:role]" do
      get :new, :content_item_id => 1, :role => 'guest', :letter => 'A'
      assigns[:role].should == 'guest'
    end
  end

  describe "POST create" do
    before(:each) do
      Person.stub(:find).and_return(stub_person)
      @content_item.stub!(:add_person).and_return(true)
    end
    it "should find the person" do
      Person.should_receive(:find).with("2").and_return(stub_person)
      post :create, :content_item_id => 1, :person_id => 2
    end
    it "should assign the person variable" do
      post :create, :content_item_id => 1, :person_id => 2
      assigns(:person).should == stub_person
    end
    it "should add the person to the content item" do
      @content_item.should_receive(:add_person).and_return(true)
      post :create, :content_item_id => 1, :person_id => 2
    end
    it "should redirect to the content items people index path" do
      post :create, :content_item_id => 1, :person_id => 2
      response.should redirect_to admin_content_item_content_items_people_path(@content_item)
    end

  end

  describe "DELETE destroy" do

    before(:each) do
      Person.stub(:find).and_return(stub_person)
      @content_item.stub!(:delete_person).and_return(true)
    end
    it "should find the person" do
      Person.should_receive(:find).with("2").and_return(stub_person)
      delete :destroy, :content_item_id => 1, :id => 2
    end
    it "should assign the person variable" do
      delete :create, :content_item_id => 1, :id => 2
      assigns(:person).should == stub_person
    end
    it "should delete the person in the content item" do
      @content_item.should_receive(:delete_person).and_return(true)
      delete :destroy, :content_item_id => 1, :id => 2
    end
    it "should redirect to the content items people index path" do
      delete :destroy, :content_item_id => 1, :id => 2
      response.should redirect_to admin_content_item_content_items_people_path(@content_item)
    end


  end

end

