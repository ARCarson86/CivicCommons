require 'spec_helper'

module Admin
  describe CuratedFeedItemsController do

    before(:each) do
      sign_in Factory.create(:admin_person)
    end

    let(:curated_feed) do
      Factory.create(:curated_feed)
    end

    describe "GET index" do

      before(:each) do
        @curated_feed_items = {}
        (1..5).each do 
          curated_feed_item = Factory.create(:curated_feed_item)
          @curated_feed_items[curated_feed_item.id] = curated_feed_item
        end
      end

      it "assigns all curated_feed_items as @curated_feed_items" do
        get :index, :curated_feed_id => curated_feed.id
        assigns[:curated_feed_items].size.should == @curated_feed_items.size
      end
    end

    describe "GET show" do

      let(:curated_feed_item) do
        Factory.create(:curated_feed_item)
      end

      it "assigns the requested curated_feed_item as @curated_feed_item" do
        get :show, :curated_feed_id => curated_feed.id, :id => curated_feed_item.id.to_s
        assigns[:curated_feed_item].should eq curated_feed_item
      end

    end

    describe "GET new" do

      it "assigns a new curated_feed_item as @curated_feed_item" do
        get :new, :curated_feed_id => curated_feed.id
        assigns[:curated_feed_item].should_not be_nil
      end

    end

    describe "GET edit" do

      let(:curated_feed_item) do
        Factory.create(:curated_feed_item)
      end

      it "assigns the requested curated_feed_item as @curated_feed_item" do
        get :edit, :curated_feed_id => curated_feed.id, :id => curated_feed_item.id.to_s
        assigns[:curated_feed_item].should eq curated_feed_item
      end

    end

    describe "POST create" do

      describe "with valid params" do

        let(:params) do
          Factory.attributes_for(:curated_feed_item)
        end

        before(:each) do
          post :create, :curated_feed_id => curated_feed.id, :curated_feed_item => params
        end

        it "assigns a newly created curated_feed_item as @curated_feed_item" do
          assigns[:curated_feed_item].name.should eq params[:name]
          assigns[:curated_feed_item].cached_slug.should eq params[:cached_slug]
          assigns[:curated_feed_item].template.should eq params[:template]
        end

        it "redirects to the created curated_feed_item" do
          response.should redirect_to admin_curated_feed_item_path(curated_feed, assigns[:curated_feed_item].cached_slug)
        end

      end

      describe "with invalid params" do

        let(:params) do
          Factory.attributes_for(:curated_feed_item)
        end

        before(:each) do
          params.delete(:name)
          post :create, :curated_feed_id => curated_feed.id, :curated_feed_item => params
        end

        it "assigns a newly created but unsaved curated_feed_item as @curated_feed_item" do
          assigns[:curated_feed_item].template.should eq params[:template]
        end

        it "re-renders the 'new' template" do
          response.should render_template('new')
        end

      end

    end

    describe "PUT update" do

      let(:curated_feed_item) do
        Factory.create(:curated_feed_item)
      end

      let(:new_name) do
        "Some completely different but valid name"
      end

      let(:new_slug) do
        "some-completely-different-but-valid-name"
      end

      let(:params) do
        curated_feed_item.attributes
      end

      describe "with valid params" do

        before(:each) do
          params['name'] = new_name
          put :update, :curated_feed_id => curated_feed.id, :id => params['id'], :curated_feed_item => params
        end

        it "updates the requested curated_feed_item" do
          CuratedFeedItem.find_by_id(params['id']).name.should eq new_name
        end

        it "assigns the requested curated_feed_item as @curated_feed_item" do
          assigns[:curated_feed_item].id.should eq params['id']
          assigns[:curated_feed_item].name.should eq new_name
          assigns[:curated_feed_item].template.should eq params['template']
          assigns[:curated_feed_item].cached_slug.should eq new_slug
        end

        it "redirects to the 'GET show' curated_feed_item" do
          response.should redirect_to admin_curated_feed_item_path(curated_feed, new_slug)
        end

      end

      describe "with invalid params" do

        before(:each) do
          params['name'] = ''
          put :update, :curated_feed_id => curated_feed.id, :id => params['id'], :curated_feed_item => params
        end

        it "assigns the curated_feed_item as @curated_feed_item" do
          assigns[:curated_feed_item].id.should eq params['id']
          assigns[:curated_feed_item].name.should eq params['name']
          assigns[:curated_feed_item].template.should eq params['template']
          assigns[:curated_feed_item].cached_slug.should eq params['cached_slug']
        end

        it "re-renders the 'edit' template" do
          response.should render_template('edit')
        end

      end

    end

    describe "DELETE destroy" do

      let(:curated_feed_item) do
        Factory.create(:curated_feed_item)
      end

      before(:each) do
        delete :destroy, :curated_feed_id => curated_feed.id, :id => curated_feed_item.id
      end

      it "destroys the requested curated_feed_item" do
        CuratedFeedItem.find_by_id(curated_feed_item.id).should be_nil
      end

      it "redirects to the curated_feed_items list" do
        response.should redirect_to(admin_curated_feed_items_path(curated_feed))
      end

    end

  end
end
