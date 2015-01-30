require 'spec_helper'

describe Admin::WidgetStatsHelper do
  def mock_widget_log(attributes={})
    @mock_widget_log ||= mock_model(WidgetLog, attributes.merge({:url => 'widget/url/here'}))
  end
  
  before(:all) do
    # This is needed so that test do not fail intermittently.
    Timecop.travel(DateTime.parse('01 Jun 2012 5AM'))
  end

  after(:all) do
    Timecop.return
  end
  
  describe "weeks_ago_date_range_select" do
    
    it "should return the correct selection for dates" do
      helper.weeks_ago_date_range_select(5).should == [["Mon, May 28, 2012 - Sun, June 03, 2012", 0], ["Mon, May 21, 2012 - Sun, May 27, 2012", 1], ["Mon, May 14, 2012 - Sun, May 20, 2012", 2], ["Mon, May 07, 2012 - Sun, May 13, 2012", 3], ["---------", "none", {:disabled=>true}], ["Mon, April 30, 2012 - Sun, May 06, 2012", 4], ["Mon, April 23, 2012 - Sun, April 29, 2012", 5]]
    end
  end
  
  describe "url_for_widget_stat" do
    it "should return the correct url" do
      helper.url_for_widget_stat(mock_widget_log).should == "/admin/widget_stats/widget/url/here"
    end
  end
  
  describe "first_week_of_month" do
    it "should corretly display which week ago is the first week" do
      helper.first_week_of_month?(0).should be_false
      helper.first_week_of_month?(1).should be_false
      helper.first_week_of_month?(2).should be_false
      helper.first_week_of_month?(3).should be_true
      helper.first_week_of_month?(4).should be_false
    end
  end
end
