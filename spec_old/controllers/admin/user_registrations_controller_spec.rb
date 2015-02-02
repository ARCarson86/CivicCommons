require 'spec_helper'

module Admin

  describe UserRegistrationsController do

    before(:each) do
      @admin_person = FactoryGirl.create(:admin_person)
      @controller.stub(:current_person).and_return(@admin_person)
    end

    describe "GET: new" do

      it "assigns a new person to @person" do
        person = mock_model(Person)
        Person.should_receive(:new).and_return(person)

        get :new
        assigns(:person).should == person
      end

    end

    describe "POST: create" do

      context "Valid Person" do

        it "creates an instance of Person as @person" do
          person = mock_model(Person)
          Person.should_receive(:new).and_return(person)
          person.stub(:confirm!).and_return(true)

          post :create
          assigns(:person).should == person
        end

        it "Redirects them to admin people" do
          person = mock_model(Person)
          Person.stub(:new).and_return(person)
          person.stub(:confirm!).and_return(true)

          post :create
          controller.should redirect_to admin_people_path
        end

      end

      context "Invalid Person" do

        def do_create
          params = FactoryGirl.attributes_for(:normal_person)
          params.delete(:email)
          post :create, person: params
        end

        it "Renders the new template" do
          do_create
          controller.should render_template(:new)
        end

      end

    end

  end

end
