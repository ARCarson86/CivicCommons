#passed
require 'spec_helper'

describe MetroRegion do
  context "Associations" do
    it { should have_many :conversations}
  end
  context "top_metro_regions" do
    def given_conversations_and_metro_regions
      5.times {FactoryGirl.create(:metro_region)}
      @metro_regions = MetroRegion.all
      @metro_regions.each do |metro|
        FactoryGirl.create(:conversation, :metro_region_id => metro.id)
      end
    end
    
    it "should return the correct number of metro regions" do
      given_conversations_and_metro_regions
      MetroRegion.top_metro_regions.length.should == 5
    end
    
    it "should return the correct metro regions" do
      given_conversations_and_metro_regions
      5.times do |i|
        MetroRegion.top_metro_regions.include?(@metro_regions[i]).should be_true
      end
    end
    
    it "should return a different number of results if a parameter is passed" do
      given_conversations_and_metro_regions
      MetroRegion.top_metro_regions(3).length.should == 3
      MetroRegion.top_metro_regions(10).length.should == 5
    end
    
  end
end
