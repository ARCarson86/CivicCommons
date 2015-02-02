require 'spec_helper'

# Conversation has a default_image set
# Issue does not have a default_url set

describe "instance methods" do

  it "will have default_image method" do
    Conversation.new.methods.include?(:default_image).should be_true
    Issue.new.methods.include?(:default_image).should be_true
  end

  it "will have default_image? method" do
    Conversation.new.methods.include?(:default_image?).should be_true
    Issue.new.methods.include?(:default_image?).should be_true
  end

  it "will have custom_image? method" do
    Conversation.new.methods.include?(:custom_image?).should be_true
    Issue.new.methods.include?(:custom_image?).should be_true
  end
end

describe "custom_image?" do
  it "will return false if image is set, it has a :default_url and it is not set to it" do
    instance = FactoryGirl.build(:conversation) # class has a :default_url
    instance.custom_image?.should be_false

    instance.image = nil
    instance.custom_image?.should be_false

    instance.image = File.new(Rails.root + 'spec/fixtures/images/test_image.jpg')
    instance.custom_image?.should be_true

    instance = FactoryGirl.build(:issue) # class does not have a :default_url
    instance.custom_image?.should be_true

    # this appears incorret, but paperclip adds a default url of 'images/:style/missing.png'
    # if one is not set
    instance.image = nil
    instance.custom_image?.should be_true
  end
end

describe "default_image" do
  it "will return paperclip's :default_url if set, or nil" do
    instance = FactoryGirl.build(:conversation)
    instance.default_image.should == 'convo_img_original.gif'

    instance = FactoryGirl.build(:issue)
    instance.default_image.should == nil
  end
end

describe "default_image?" do
  it "will return true if image has a :default_url and is set to it" do
    instance = FactoryGirl.build(:conversation)
    instance.default_image?.should be_true

    instance.image = File.new(Rails.root + 'spec/fixtures/images/test_image.jpg')
    instance.default_image?.should be_false

    instance = FactoryGirl.build(:issue)
    instance.default_image?.should be_false
  end
end
