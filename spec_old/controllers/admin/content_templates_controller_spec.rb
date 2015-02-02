require 'spec_helper'

module Admin
  describe ContentTemplatesController do

    before(:each) do
      sign_in FactoryGirl.create(:admin_person)
    end

    describe "GET index" do

      before(:each) do
        @content_templates = {}
        (1..5).each do 
          template = FactoryGirl.create(:content_template)
          @content_templates[template.id] = template
        end
      end

      it "assigns all content_templates as @content_templates" do
        get :index
        assigns[:content_templates].size.should == @content_templates.size
      end

    end

    describe "GET show" do

      let(:template) do
        FactoryGirl.create(:content_template)
      end

      it "assigns the requested content_template as @content_template" do
        get :show, :id => template.id.to_s
        assigns[:content_template].should eq template
      end

    end

    describe "GET new" do

      it "assigns a new content_template as @content_template" do
        get :new
        assigns[:content_template].should_not be_nil
      end

    end

    describe "GET edit" do

      let(:template) do
        FactoryGirl.create(:content_template)
      end

      it "assigns the requested content_template as @content_template" do
        get :edit, :id => template.id.to_s
        assigns[:content_template].should eq template
      end

    end

    describe "POST create" do

      describe "with valid params" do

        let(:params) do
          FactoryGirl.attributes_for(:content_template)
        end

        before(:each) do
          post :create, :content_template => params
        end

        it "assigns a newly created content_template as @content_template" do
          assigns[:content_template].name.should eq params[:name]
          assigns[:content_template].template.should eq params[:template]
        end

        it "redirects to the created content_template" do
          response.should redirect_to admin_content_template_path(assigns[:content_template].slug)
        end

      end

      describe "with invalid params" do

        let(:params) do
          FactoryGirl.attributes_for(:content_template)
        end

        before(:each) do
          params.delete(:name)
          post :create, :content_template => params
        end

        it "assigns a newly created but unsaved content_template as @content_template" do
          assigns[:content_template].template.should eq params[:template]
        end

        it "re-renders the 'new' template" do
          response.should render_template('new')
        end

      end

    end

    describe "PUT update" do

      let(:template) do
        FactoryGirl.create(:content_template)
      end

      let(:new_name) do
        "Some completely different but valid name"
      end

      let(:params) do
        template.attributes
      end

      describe "with valid params" do

        before(:each) do
          params['name'] = new_name
          put :update, :id => params['id'], :content_template => params
        end

        it "updates the requested content_template" do
          ContentTemplate.find_by_id(params['id']).name.should eq new_name
        end

        it "assigns the requested content_template as @content_template" do
          assigns[:content_template].id.should eq params['id']
          assigns[:content_template].name.should eq new_name
          assigns[:content_template].template.should eq params['template']
        end

        it "redirects to the 'GET show' page" do
          response.should redirect_to admin_content_template_path(template)
        end

      end

      describe "with invalid params" do

        before(:each) do
          params['name'] = ''
          put :update, :id => params['id'], :content_template => params
        end

        it "assigns the content_template as @content_template" do
          assigns[:content_template].id.should eq params['id']
          assigns[:content_template].name.should eq params['name']
          assigns[:content_template].template.should eq params['template']
        end

        it "re-renders the 'edit' template" do
          response.should render_template('edit')
        end

      end

    end

    describe "DELETE destroy" do

      let(:template) do
        FactoryGirl.create(:content_template)
      end

      before(:each) do
        delete :destroy, :id => template.id
      end

      it "destroys the requested content_template" do
        ContentTemplate.find_by_id(template.id).should be_nil
      end

      it "redirects to the content_templates list" do
        response.should redirect_to(admin_content_templates_path)
      end

    end

  end
end
