# passing
require 'spec_helper'

describe ContentItemDescription do
  context "validations" do
    let(:radio_show_description) { FactoryGirl.build(:radio_show_description) }

    it "factory creates a valid object" do
      FactoryGirl.build(:blog_post_description).should be_valid
      radio_show_description.should be_valid
    end

    it "validates the presence of content_type" do
      radio_show_description.content_type = nil
      radio_show_description.should_not be_valid

      radio_show_description.content_type = 'NewsItem'
      radio_show_description.should_not be_valid
    end

    it "validates the uniqueness of content_type" do
      radio_show_description.save
      radio_show_description2 = FactoryGirl.build(:radio_show_description)
      radio_show_description2.should_not be_valid
    end

    it "validates the value of content_type" do
      radio_show_description.content_type = 'ContentItem'
      radio_show_description.should_not be_valid
    end

    it "validates the presence of description_short" do
      radio_show_description.description_short = nil
      radio_show_description.should_not be_valid
    end

    it "validates the presence of description_long" do
      radio_show_description.description_short = nil
      radio_show_description.should_not be_valid
    end
  end
end
