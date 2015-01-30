require 'spec_helper'

module Admin
  describe CuratedFeedsController do

    before(:each) do
      sign_in FactoryGirl.create(:admin_person)
    end

    describe "GET index" do

      before(:each) do
        @feeds = {}
        (1..2).each do 
          feed = FactoryGirl.create(:curated_feed)
          @feeds[feed.id] = feed
        end
      end

      it "assigns all feeds as @feeds" do
        get :index
        assigns[:feeds].size.should == @feeds.size
      end

    end

    describe "GET show" do

      let(:feed) do
        FactoryGirl.create(:curated_feed)
      end

      it "assigns the requested feed as @feed" do
        get :show, :id => feed.id.to_s
        assigns[:feed].should eq feed
      end

    end

    describe "GET new" do

      it "assigns a new feed as @feed" do
        get :new
        assigns[:feed].should_not be_nil
      end

    end

    describe "GET edit" do

      let(:feed) do
        FactoryGirl.create(:curated_feed)
      end

      it "assigns the requested feed as @feed" do
        get :edit, :id => feed.id.to_s
        assigns[:feed].should eq feed
      end

    end

    describe "POST create" do

      describe "with valid params" do

        let(:params) do
          FactoryGirl.attributes_for(:curated_feed)
        end

        before(:each) do
          post :create, :curated_feed => params
        end

        it "assigns a newly created feed as @feed" do
          assigns[:feed].title.should eq params[:title]
          assigns[:feed].description.should eq params[:description]
        end

        it "redirects to the created feed" do
          response.should redirect_to admin_curated_feed_path(assigns[:feed])
        end

      end

      describe "with invalid params" do

        let(:params) do
          FactoryGirl.attributes_for(:curated_feed)
        end

        before(:each) do
          params.delete(:title)
          post :create, :curated_feed => params
        end

        it "assigns a newly created but unsaved feed as @feed" do
          assigns[:feed].description.should eq params[:description]
        end

        it "re-renders the 'new' feed" do
          response.should render_template('new')
        end

      end


      describe "PUT update" do

        let(:feed) do
          FactoryGirl.create(:curated_feed)
        end

        let(:new_title) do
          "Some completely different but valid title"
        end

        let(:params) do
          feed.attributes
        end

        describe "with valid params" do

          before(:each) do
            params['title'] = new_title
            put :update, :id => params['id'], :curated_feed => params
          end

          it "updates the requested feed" do
            CuratedFeed.find_by_id(params['id']).title.should eq new_title
          end

          it "assigns the requested feed as @feed" do
            assigns[:feed].id.should eq params['id']
            assigns[:feed].title.should eq new_title
            assigns[:feed].description.should eq params['description']
          end

          it "redirects to the 'GET show' page" do
            response.should redirect_to admin_curated_feed_path(feed)
          end

        end

        describe "with invalid params" do

          before(:each) do
            params.delete('published')
            params['title'] = ''
            put :update, :id => params['id'], :curated_feed => params
          end

          it "assigns the feed as @feed" do
            assigns[:feed].id.should eq params['id']
            assigns[:feed].title.should eq params['title']
            assigns[:feed].description.should eq params['description']
          end

          it "re-renders the 'edit' feed" do
            response.should render_template('edit')
          end

        end

      end

      describe "DELETE destroy" do

        let(:feed) do
          FactoryGirl.create(:curated_feed)
        end

        before(:each) do
          delete :destroy, :id => feed.id
        end

        it "destroys the requested feed" do
          CuratedFeed.find_by_id(feed.id).should be_nil
        end

        it "redirects to the feeds list" do
          response.should redirect_to(admin_curated_feeds_path)
        end

      end

    end
  end
end
