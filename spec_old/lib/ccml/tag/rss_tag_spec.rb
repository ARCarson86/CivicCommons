require 'spec_helper'
#WebMock.allow_net_connect!

describe CCML::Tag::RssTag do
  include StubbedHttpRequests

  let(:rss_content) do
    fixture_content('blog_rss.xml')
  end

  let(:rss_url) do
    'http://feeds.theciviccommons.com/civiccommonsblog'
  end
  
  let(:invalid_rss_url) do
    'http://feeds.example.com/invalid-rss-feed'
  end

  let(:page_url) do
    'http://www.theciviccommons.com/issues/flats-forward'
  end

  before(:each) do
    stub_request(:get, rss_url).
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => rss_content, :headers => {})
      
    stub_request(:get, invalid_rss_url).
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => '', :headers=>{})
  end

  context "feed retrieval" do

    it "retrieves a valid RSS feed" do
      tag = CCML::Tag::RssTag.new({url: rss_url}, page_url)
      tag.tag_body = "anything"
      tag.index.should_not be_blank
    end

    it "gracefully handles a missing feed URL" do
      tag = CCML::Tag::RssTag.new({}, page_url)
      tag.tag_body = "anything"
      tag.index.should be_blank
    end

    it "gracefully handles a bad feed" do
      tag = CCML::Tag::RssTag.new({url: 'bad_url'}, page_url)
      tag.tag_body = "anything"
      tag.index.should be_blank
    end

  end

  context "caching" do

    before(:each) do
      Rails.cache.clear
    end

    it "retrieves new data when no refresh is given" do
      RSS::Parser.should_receive(:parse).and_return(nil)
      tag = CCML::Tag::RssTag.new({url: rss_url}, page_url)
      tag.tag_body = "anything"
      tag.index
    end

    it "retrieves new data when the cache is older than the refresh (in minutes)" do
      RSS::Parser.should_receive(:parse).and_return(nil)
      Timecop.travel(1.hour.since)
      tag = CCML::Tag::RssTag.new({url: rss_url, refresh: 30}, page_url)
      tag.tag_body = "anything"
      tag.index
    end

    it "uses cached data when the cache is newer than the refresh (in minutes)" do
      RSS::Parser.should_not_receive(:parse)
      Timecop.travel(1.hour.since)
      tag = CCML::Tag::RssTag.new({url: rss_url, refresh: 30}, page_url)
      tag.tag_body = "anything"
      tag.index
    end

    it "always caches the the parsed rss data" do
      Rails.cache.should_receive(:write).twice
      tag = CCML::Tag::RssTag.new({url: rss_url, refresh: 10}, page_url)
      tag.tag_body = "anything"
      tag.index
      Timecop.travel(1.minute.since)
      tag.index
    end

  end

  context "#index" do

    let(:tag_body) do
      <<-tag_body
      {ccml:rss}
        RSS Version: {rss_version}<br />
        RSS Feed Version: {rss_feed_version}<br />
        RSS Feed Type: {rss_feed_type}<br />
        Channel Title: {channel_title}<br />
        Channel Description: {channel_description}<br />
        Channel Copyright: {channel_copyright}<br />
        Channel Link: {channel_link}<br />
        Channel Language: {channel_language}<br />
        Channel Publication Date: {channel_date format='%m-%d-%Y %I:%M %p'}<br />
        Channel Image Title: {channel_image_title}<br />
        Channel Image URL: {channel_image_url}<br />
        Channel Image Link: {channel_image_link}<br />
        Channel Image Description: {channel_image_description}<br />
        Channel Image Height: {channel_image_height}<br />
        Channel Image Width: {channel_item_width}<br />
        Channel Item Count: {channel_item_count}<br />
        Item Title: {item_title}<br />
        Item Link: {item_link}<br />
        Item Description: {item_description}<br />
        Item Publication Date: {item_date format='%m-%d-%Y %I:%M %p'}<br />
      {/ccml:rss}
      tag_body
    end

    it "exposes the channel attributes" do
      tag = CCML::Tag::RssTag.new({url: rss_url}, page_url)
      tag.tag_body = tag_body
      html = tag.index
      html.should =~ /RSS Version: 1\.0/i
      html.should =~ /RSS Feed Version: 2\.0/i
      html.should =~ /RSS Feed Type: rss/i
      html.should =~ /RSS Version: 1\.0/i
      html.should =~ /Channel Title: The Civic Commons: Common Blog/i
      html.should =~ /Channel Description: The Civic Commons is a new way to bring communities/i
      html.should =~ /Channel Copyright: \(c\) Copyright \d{4} The Civic Commons/i
      html.should =~ /Channel Link: http:\/\/www\.theciviccommons\.com\/blog/i
      html.should =~ /Channel Language: en-us/i
      html.should =~ /Channel Publication Date: 05-12-2011/i
      html.should =~ /Channel Image URL: http:\/\/www\.theciviccommons\.com\/images\/cc_podcast\.jpg/i
      html.should =~ /Channel Image Title: The Civic Commons: Common Blog/i
      html.should =~ /Channel Image Link: http:\/\/www\.theciviccommons\.com\/blog/i
      html.should =~ /Channel Image Description: /i
      html.should =~ /Channel Image Height: /i
      html.should =~ /Channel Image Width: /i
      html.should =~ /Channel Item Count: 13/i
    end

    it "exposes the correct item attributes on all iterations" do
      tag = CCML::Tag::RssTag.new({url: rss_url}, page_url)
      tag.tag_body = tag_body
      html = tag.index
      html.should =~ /Item Title: Feedback Loop/i
      html.should =~ /Item Link: http:\/\/www\.theciviccommons\.com\/blog\/feedback-loop/i
      html.should =~ /Item Description: .*I had coffee this morning with a boomeranging Clevelander./i
      html.should =~ /Item Publication Date: 05-09-2011/i
    end

    it "returns no more items than specified by the limit option" do
      tag = CCML::Tag::RssTag.new({url: rss_url, limit: 10}, page_url)
      tag.tag_body = tag_body
      html = tag.index
      html.should =~ /Channel Item Count: 10/i
    end
 
    it "returns all items if the limit option is greater than the number of items" do
      tag = CCML::Tag::RssTag.new({url: rss_url, limit: 100}, page_url)
      tag.tag_body = tag_body
      html = tag.index
      html.should =~ /Channel Item Count: 13/i
    end

  end

  context "#channel" do

    let(:tag_body) do
      <<-tag_body
      {ccml:rss:channel}
        RSS Version: {rss_version}<br />
        RSS Feed Version: {rss_feed_version}<br />
        RSS Feed Type: {rss_feed_type}<br />
        Title: {title}<br />
        Description: {description}<br />
        Copyright: {copyright}<br />
        Link: {link}<br />
        Language: {language}<br />
        Publication Date: {date format='%m-%d-%Y %I:%M %p'}<br />
        Image Title: {image_title}<br />
        Image URL: {image_url}<br />
        Image Link: {image_link}<br />
        Image Description: {image_description}<br />
        Image Height: {image_height}<br />
        Image Width: {item_width}<br />
        Item Count: {item_count}<br />
      {/ccml:rss:channel}
      tag_body
    end

    it "exposes the channel attributes" do
      tag = CCML::Tag::RssTag.new({url: rss_url}, page_url)
      tag.tag_body = tag_body
      html = tag.channel
      html.should =~ /RSS Version: 1\.0/i
      html.should =~ /RSS Feed Version: 2\.0/i
      html.should =~ /RSS Feed Type: rss/i
      html.should =~ /Title: The Civic Commons: Common Blog/i
      html.should =~ /Description: The Civic Commons is a new way to bring communities/i
      html.should =~ /Copyright: \(c\) Copyright \d{4} The Civic Commons/i
      html.should =~ /Link: http:\/\/www\.theciviccommons\.com\/blog/i
      html.should =~ /Language: en-us/i
      html.should =~ /Publication Date: 05-12-2011/i
      html.should =~ /Image URL: http:\/\/www\.theciviccommons\.com\/images\/cc_podcast\.jpg/i
      html.should =~ /Image Title: The Civic Commons: Common Blog/i
      html.should =~ /Image Link: http:\/\/www\.theciviccommons\.com\/blog/i
      html.should =~ /Image Description: /i
      html.should =~ /Image Height: /i
      html.should =~ /Image Width: /i
      html.should =~ /Item Count: 13/i
    end
  end

  context "#items" do
    before(:all) do
      stub_request(:get, invalid_rss_url).
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => '', :headers=>{})
    end

    let(:tag_body) do
      <<-tag_body
      {ccml:rss:items}
        Title: {title}<br />
        Link: {link}<br />
        Description: {description}<br />
        Publication Date: {date format='%m-%d-%Y %I:%M %p'}<br />
      {/ccml:rss:items}
      tag_body
    end

    it "exposes the correct item attributes on all iterations" do
      tag = CCML::Tag::RssTag.new({url: rss_url}, page_url)
      tag.tag_body = tag_body
      html = tag.items
      html.should =~ /Title: Feedback Loop/i
      html.should =~ /Link: http:\/\/www\.theciviccommons\.com\/blog\/feedback-loop/i
      html.should =~ /Title: Mobile Town Hall/i
      html.should =~ /Link: http:\/\/www\.theciviccommons\.com\/blog\/mobile-town-hall/i
      html.should =~ /Title: A Great Experiment/i
      html.should =~ /Link: http:\/\/www\.theciviccommons\.com\/blog\/a-great-experiment/i
    end
 
    it "returns no more items than specified by the limit option" do
      tag = CCML::Tag::RssTag.new({url: rss_url, limit: 1}, page_url)
      tag.tag_body = tag_body
      html = tag.items
      html.should_not =~ /Title: Some stuff worth looking at (if you've never seen them)/i
      html.should_not =~ /Link: http:\/\/www\.theciviccommons\.com\/blog\/some-stuff-worth-looking-at-if-youve-never-seen-them/i
    end
 
    it "returns all items if the limit option is greater than the number of items" do
      tag = CCML::Tag::RssTag.new({url: rss_url, limit: 100}, page_url)
      tag.tag_body = tag_body
      html = tag.items
      html.should =~ /Title: Feedback Loop/i
      html.should =~ /Link: http:\/\/www\.theciviccommons\.com\/blog\/feedback-loop/i
      html.should =~ /Title: A Great Experiment/i
      html.should =~ /Link: http:\/\/www\.theciviccommons\.com\/blog\/a-great-experiment/i
    end
    
    it "should raise a CCML::Error::ExternalSourceError when it's url result is invalid" do      
      tag = CCML::Tag::RssTag.new({url: invalid_rss_url, limit: 100}, page_url)
      tag.tag_body = tag_body
      expect { tag.items }.should raise_error(CCML::Error::ExternalSourceError)
    end
 end

end
