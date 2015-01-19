require 'spec_helper'

describe SearchService do
  
  def create_hit(result)
    hit = double("Hit")
    hit.stub(:result) { result }
    hit
  end
  
  context "Initialization" do

    before(:each) do
      @mock_search = mock('search')
      @search = SearchService.new(@mock_search)
    end

    it "should pass all options through to Search" do
      params = Hash.new
      params[:q] = "Town"

      @mock_search.should_receive(:search).with([Conversation]).and_return(@mock_search)
      @mock_search.should_receive(:hits).and_return([])
      @search.fetch_results(params[:q], :models => Conversation).should == []
    end

    it "should return an empty set of results" do
      @mock_search.should_receive(:search).and_return(@mock_search)
      @mock_search.should_receive(:hits).and_return([])
      @search.fetch_results().should == []
    end

    it "will not return unconfirmed contributions in search results", :search => true do
      confirmed_contribution_hit = create_hit(FactoryGirl.build(:contribution, content: 'Confirmed Contribution'))
      unconfirmed_contribution_hit = create_hit(FactoryGirl.build(:unconfirmed_contribution, content: 'Unconfirmed Contribution'))
      @mock_search.stub(:search) { @mock_search }
      @mock_search.stub(:hits) { [confirmed_contribution_hit, unconfirmed_contribution_hit] }
      @search.fetch_results('contribution', Contribution).should == [confirmed_contribution_hit]
    end

  end
end
