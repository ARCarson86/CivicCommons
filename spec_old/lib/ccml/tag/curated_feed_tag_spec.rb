require 'spec_helper'

describe CCML::Tag::CuratedFeedTag do

  context "#index method" do

    before(:each) do
      @curated_feed = FactoryGirl.create(:curated_feed)
      @url = "http://www.theciviccommons.com/feeds/#{@curated_feed.slug}"
      @tag_body = '{id} "{title}" {slug}'
      @tag_regexp = Regexp.new("#{@curated_feed.id} \"#{@curated_feed.title}\" #{@curated_feed.slug}")
    end

    it "accepts an id as opts id" do
      tag = CCML::Tag::CuratedFeedTag.new({id: @curated_feed.id}, @url)
      tag.tag_body = @tag_body
      tag.index.should =~ @tag_regexp
    end

    it "accepts a slug as opts id" do
      tag = CCML::Tag::CuratedFeedTag.new({id: @curated_feed.slug}, @url)
      tag.tag_body = @tag_body
      tag.index.should =~ @tag_regexp
    end

    it "gets the id from segment 1 if no id is given" do
      tag = CCML::Tag::CuratedFeedTag.new({}, @url)
      tag.tag_body = @tag_body
      tag.index.should =~ @tag_regexp
    end

    it "returns blank if the requested curated_feed is not found" do
      tag = CCML::Tag::CuratedFeedTag.new({id: 0}, @url)
      tag.tag_body = @tag_body
      tag.index.should be_blank
    end

  end

  context "#all method" do

    before(:each) do
      @tag_body = '{id} "{title}" {slug}'
    end

    it "returns all curated feeds" do
      feeds = []
      3.times {|i| feeds << FactoryGirl.create(:curated_feed) }
      tag = CCML::Tag::CuratedFeedTag.new({})
      tag.tag_body = @tag_body
      output = tag.all
      feeds.each do |feed|
        output.should =~ /#{feed.id} \"#{feed.title}\" #{feed.slug}/
      end
    end

    it "returns blank when no curated feeds exist" do
      tag = CCML::Tag::CuratedFeedTag.new({})
      tag.tag_body = @tag_body
      tag.all.should be_blank
    end

  end

  context "#items method" do

    before(:each) do
      @feed = FactoryGirl.create(:curated_feed)
      @tag_body = '{id} "{title}" {original_url}'
    end

    context "limiting" do
      before(:each) do
        @first_feed = FactoryGirl.create(:curated_feed_item, curated_feed: @feed, created_at: 0.days.ago, pub_date: 0.days.ago)
                      FactoryGirl.create(:curated_feed_item, curated_feed: @feed, created_at: 1.days.ago, pub_date: 1.days.ago)
                      FactoryGirl.create(:curated_feed_item, curated_feed: @feed, created_at: 2.days.ago, pub_date: 2.days.ago)
                      FactoryGirl.create(:curated_feed_item, curated_feed: @feed, created_at: 3.days.ago, pub_date: 3.days.ago)
        @fifth_feed = FactoryGirl.create(:curated_feed_item, curated_feed: @feed, created_at: 4.days.ago, pub_date: 4.days.ago)
        @sixth_feed = FactoryGirl.create(:curated_feed_item, curated_feed: @feed, created_at: 5.days.ago, pub_date: 5.days.ago)
      end

      it "returns all feed items if no limit is specified" do
        tag = CCML::Tag::CuratedFeedTag.new({id: @feed.id})
        tag.tag_body = @tag_body
        output = tag.items

        # Make sure each of the feed items are in the output
        curated_feed = CuratedFeed.find(@feed.id)
        items = curated_feed.curated_feed_items
        items.each do |item|
          output.should =~ /#{item.id} \"#{item.title}\" #{item.original_url}/
        end
        output.should =~ /.*#{@first_feed.original_url}.*#{@sixth_feed.original_url}/ # Newest Feed comes first.
      end

      it "returns all feed items if limit is negative" do
        tag = CCML::Tag::CuratedFeedTag.new({id: @feed.id, limit: '-1'})
        tag.tag_body = @tag_body
        output = tag.items

        # Make sure each of the feed items are in the output
        curated_feed = CuratedFeed.find(@feed.id)
        items = curated_feed.curated_feed_items
        items.each do |item|
          output.should =~ /#{item.id} \"#{item.title}\" #{item.original_url}/
        end
        output.should =~ /.*#{@first_feed.original_url}.*#{@sixth_feed.original_url}/ # Newest Feed comes first.
      end

      it "returns X most recent if a limit is specified" do
        limit = 5
        tag = CCML::Tag::CuratedFeedTag.new({ id: @feed.id, limit: limit.to_s })
        tag.tag_body = @tag_body
        output = tag.items

        # Make sure each of the feed items are in the output
        curated_feed = CuratedFeed.find(@feed.id)
        items = curated_feed.curated_feed_items.limit(limit)
        items.each do |item|
          output.should =~ /#{item.id} \"#{item.title}\" #{item.original_url}/
        end

        output.should =~ /.*#{@first_feed.original_url}.*#{@fifth_feed.original_url}/ # Newest Feed comes first.
        output.should_not =~ /#{@sixth_feed.original_url}/ # Sixth feed should not be incldued in 5 most recent.
      end
    end

    it "returns blank if the feed is not found" do
      tag = CCML::Tag::CuratedFeedTag.new({})
      tag.tag_body = @tag_body
      tag.items.should be_blank
    end

    it "returns blank if the feed has no items" do
      tag = CCML::Tag::CuratedFeedTag.new({id: @feed.id})
      tag.tag_body = @tag_body
      tag.items.should be_blank
    end

  end

end
