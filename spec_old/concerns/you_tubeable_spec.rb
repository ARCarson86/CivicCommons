require 'spec_helper'

describe Article, "When working with YouTube videos" do
  before(:each) do
    @model = FactoryGirl.build(:youtube_article)
  end
  context "and submitting a URL" do
    [ "http://www.example.com/this-is-not-a-valid-youtube-url" ].each do |invalid_youtube_url|
      invalid_youtube_url =~ /(http:\/\/www\.youtube\.com)?(.*)/
        invalid_youtube_url_format = $2;

      it "throws an error if URL is not a valid YouTube URL with the format #{invalid_youtube_url_format}" do
        @model.url = invalid_youtube_url
        @model.should have_validation_error(:url, /Link is not a valid YouTube URL/)
      end
    end
    [ "http://www.youtube.com/watch?v=djtNtt8jDW4", 
      "http://www.youtube.com/watch?v=G75KhTQWyDA&feature=related",
      "http://www.youtube.com/watch?v=6hiDd-HpX9I" ].each do |valid_youtube_url|
      valid_youtube_url =~ /(http:\/\/www\.youtube\.com)?(.*)/
        valid_youtube_url_format = $2;

      it "saves successfully if URL is a valid YouTube URL with the format #{valid_youtube_url_format}" do
        @model.url = valid_youtube_url
        @model.valid?.should be_true
      end
      end
  end

  context "and setting the embed code" do
    it "properly sets the embed code" do
      @model.save
      @model.embed_target.should_not be_blank
      @model.embed_target.should match /(djtNtt8jDW4)+/
    end
    it "updates the embed code if the url is updated" do
      @model.url = "http://www.youtube.com/watch?v=abcDef0gHI1"
      @model.save
      @model.embed_target.should match /(abcDef0gHI1)+/
    end
    it "properly sets embed code with hyphen" do
      @model.url = "http://www.youtube.com/watch?v=6hiDd-HpX9I"
      @model.save
      @model.embed_target.should match /(6hiDd-HpX9I)/
    end
  end
end
