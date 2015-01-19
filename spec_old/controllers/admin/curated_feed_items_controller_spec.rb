require 'spec_helper'

module Admin
  describe CuratedFeedItemsController do

    before(:each) do
      sign_in FactoryGirl.create(:admin_person)
    end

    let(:curated_feed) do
      FactoryGirl.create(:curated_feed)
    end

    describe "GET show" do

      let(:item) do
        FactoryGirl.create(:curated_feed_item)
      end

      it "assigns the requested item as @item" do
        get :show, :curated_feed_id => curated_feed.id, :id => item.id.to_s
        assigns[:item].should eq item
      end

    end

    describe "GET edit" do

      let(:item) do
        FactoryGirl.create(:curated_feed_item)
      end

      it "assigns the requested item as @item" do
        get :edit, :curated_feed_id => curated_feed.id, :id => item.id.to_s
        assigns[:item].should eq item
      end

    end

    describe "POST create" do

      describe "with valid params" do

        let(:params) do
          FactoryGirl.attributes_for(:curated_feed_item)
        end

        before(:each) do
          post :create, :curated_feed_id => curated_feed.id, :curated_feed_item => params
        end

        it "assigns a newly created item as @item" do
          assigns[:item].title.should eq params[:title]
          assigns[:item].provider_url.should eq params[:provider_url]
          assigns[:item].description.should eq params[:description]
        end

        it "redirects to the parent feed #show page" do
          response.should redirect_to admin_curated_feed_path(curated_feed)
        end

      end

      describe "with invalid params" do

        let(:params) do
          FactoryGirl.attributes_for(:curated_feed_item)
        end

        before(:each) do
          params.delete(:original_url)
          post :create, :curated_feed_id => curated_feed.id, :curated_feed_item => params
        end

        it "assigns a newly created but unsaved item as @item" do
          assigns[:item].description.should eq params[:description]
        end

        it "redirects to the parent feed #show page" do
          response.should redirect_to admin_curated_feed_path(curated_feed)
        end

      end

    end

    describe "PUT update" do

      let(:item) do
        FactoryGirl.create(:curated_feed_item)
      end

      let(:new_original_url) do
        "http://www.theciviccommons.com/some-completely-different-but-valid-url"
      end

      let(:params) do
        params = item.attributes
        params['update_embed_on_save'] = false
        params
      end

      describe "with valid params" do

        before(:each) do
          params['original_url'] = new_original_url
          put :update, :curated_feed_id => curated_feed.id, :id => params['id'], :curated_feed_item => params
        end

        it "updates the requested item" do
          CuratedFeedItem.find_by_id(params['id']).original_url.should eq new_original_url
        end

        it "assigns the requested item as @item" do
          assigns[:item].id.should eq params['id']
          assigns[:item].description.should eq params['description']
        end

        it "redirects to the 'GET show' item" do
          response.should redirect_to admin_curated_feed_path(curated_feed)
        end

      end

      describe "with invalid params" do

        before(:each) do
          params['original_url'] = ''
          put :update, :curated_feed_id => curated_feed.id, :id => params['id'], :curated_feed_item => params
        end

        it "assigns the item as @item" do
          assigns[:item].id.should eq params['id']
          assigns[:item].provider_url.should eq params['provider_url']
        end

        it "re-renders the 'edit' description" do
          response.should render_template('edit')
        end

      end

    end

    describe "DELETE destroy" do

      let(:item) do
        FactoryGirl.create(:curated_feed_item)
      end

      before(:each) do
        delete :destroy, :curated_feed_id => curated_feed.id, :id => item.id
      end

      it "destroys the requested item" do
        CuratedFeedItem.find_by_id(item.id).should be_nil
      end

      it "redirects to the items list" do
        response.should redirect_to(admin_curated_feed_path(curated_feed))
      end

    end

  end
end
