#passed
require 'spec_helper'

describe WidgetLog do
  def given_some_widget_logs
    @widget_log1 = FactoryGirl.create(:widget_log, url: '/url/here', remote_url: 'http://remote.url/here')
    @widget_log2 = FactoryGirl.create(:widget_log, url: '/url/here', remote_url: 'http://remote.url/here')
    @widget_log3 = FactoryGirl.create(:widget_log, url: '/url/here', remote_url: 'http://remote.url2/here')
  end
  describe "validations" do
    it { should validate_presence_of :url}
    it { should validate_presence_of :remote_url}
  end
  describe "find_all_url_summary_for_week" do
    it "should return the page view with the correct calculation" do
      given_some_widget_logs
      @result = WidgetLog.find_all_url_summary_for_week.first
      @result.page_views.should == 3
    end
    it "should show grouped result based on url" do
      given_some_widget_logs
      @result = WidgetLog.find_all_url_summary_for_week.first
      @result.url.should == @widget_log1.url
      @result.url.should == @widget_log2.url
      @result.url.should == @widget_log3.url
    end
    it "should return the correct number of records" do
      given_some_widget_logs
      WidgetLog.find_all_url_summary_for_week.length.should == 1
    end
  end
  
  describe "find_one_url_summary_for_week" do
    it "should return the page view with the correct calculation" do
      given_some_widget_logs
      @results = WidgetLog.find_one_url_summary_for_week('/url/here')
      @results[0].page_views.should == 2
      @results[1].page_views.should == 1
    end
    it "should show grouped result based on remote_url" do
      given_some_widget_logs
      @result = WidgetLog.find_one_url_summary_for_week(@widget_log1.url).first
      @result.remote_url.should == @widget_log1.remote_url
      @result.remote_url.should == @widget_log2.remote_url
      @result.remote_url.should_not == @widget_log3.remote_url
    end
    it "should return the correct number of records" do
      given_some_widget_logs
      WidgetLog.find_one_url_summary_for_week(@widget_log1.url).length.should == 2
    end
  end
  
  describe "add_first_slash_if_doesnt_exist" do
    it "should add the first slash if it doesn't exist" do
      WidgetLog.add_first_slash_if_doesnt_exist('url/to/here').should == '/url/to/here'
    end
    it "should just let it be, if it exists" do
      WidgetLog.add_first_slash_if_doesnt_exist('/url/to/here').should == '/url/to/here'
    end
  end
  
  describe "process_from_and_to_date" do
    before(:all) do
      # This is needed so that test do not fail intermittently.
      Timecop.travel(DateTime.parse('01 Jun 2012 5AM'))
    end

    after(:all) do
      Timecop.return
    end
    
    it "should return the correct from_date" do
      from_date, to_date = WidgetLog.process_from_and_to_date(0)
      from_date.should == '2012-05-28 04:00:00'
    end
    it "should return the correct to_date" do
      from_date, to_date = WidgetLog.process_from_and_to_date(0)
      to_date.should == '2012-06-04 03:59:59'
    end
  end
  
end
