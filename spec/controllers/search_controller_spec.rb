require 'spec_helper'

describe SearchController do
  describe "metro_region_city" do
    def stub_metro_region(options ={})
      @stub_metro_region ||= stub_model(MetroRegion, options).as_null_object
    end
    before(:each) do
      MetroRegion.stub!(:search_city_province).and_return([stub_metro_region(:id => 123,:city_display_name => 'Chicago, Illinois')])
      stub_metro_region.stub!(:results).and_return([stub_metro_region])
    end
    it "should return the result in json" do
      get :metro_region_city, :term => 'Chicago'
      response.content_type.should == 'application/json'
    end
    it "should return the correct result format" do
      get :metro_region_city, :term => 'Chicago'
      response.body.should == "[{\"id\":123,\"label\":\"Chicago, Illinois\",\"metrocode\":null}]"
    end
  end
  describe "GET results" do
    it "will render expected template" do
      get :results, :q => ''
      response.should render_template('search/results')
    end

    it "will set flash[:error] for an empty search query request and return no search results" do
      get :results, :q => ''
      should assign_to(:results).with([])
      should set_the_flash.to("You did not search for anything.  Please try again.")
    end

    it "will search a filtered set of models if requested" do
      get :results, q: '', filter: 'contributions'
      assigns[:models_to_search].should == Contribution

      get :results, q: '', filter: 'conversations'
      assigns[:models_to_search].should == Conversation

      get :results, q: '', filter: 'community'
      assigns[:models_to_search].should == Person

      get :results, q: '', filter: 'blogs'
      assigns[:models_to_search].should == ContentItem

      get :results, q: '', filter: 'radioshows'
      assigns[:models_to_search].should == ContentItem

      get :results, q: '', filter: 'projects'
      assigns[:models_to_search].should == [ManagedIssue, ManagedIssuePage]
    end

    it "will search all models if invalid filter requested" do
      get :results, q: '', filter: 'unknown'
      assigns[:models_to_search].should == [Conversation, ManagedIssue, Person, Contribution, ContentItem, ManagedIssuePage]
    end
  end
end
