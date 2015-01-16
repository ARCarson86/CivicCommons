require 'spec_helper'
require 'ostruct'

describe MetaHelper do

  context 'setup meta info' do
    it "starts with an empty meta_info object" do
      setup_meta_info(OpenStruct.new)

      @meta_info.present?.should == true
      @meta_info[:page_title].should be_nil
      @meta_info[:meta_description].should be_nil
      @meta_info[:meta_tags].should be_nil
      @meta_info[:image_url].should be_nil
    end

    describe "page title set" do
      it "using an objects title" do
        object_with_title = OpenStruct.new(:title => "Big Bad Wolf")

        setup_meta_info(object_with_title)
        @meta_info[:page_title].should == 'Big Bad Wolf'
      end

      it "using an objects cleaned up title" do
        object_with_title = OpenStruct.new(:title => "Big <b>Bad</b> Wolf")

        setup_meta_info(object_with_title)
        @meta_info[:page_title].should == 'Big Bad Wolf'
      end
    end

    describe "page meta_description set" do
      it "using an objects meta_description" do
        object_with_meta_description = OpenStruct.new(:meta_description => "The story of how a good wolf was turned into something big and bad.")

        setup_meta_info(object_with_meta_description)
        @meta_info[:meta_description].should == "The story of how a good wolf was turned into something big and bad."
      end

      it "uses an objects cleaned up meta_description" do
        object_with_meta_description = OpenStruct.new(:meta_description => "The story of how a <b>good</b> wolf was turned into something <em>big and bad</em>.")

        setup_meta_info(object_with_meta_description)
        @meta_info[:meta_description].should == "The story of how a good wolf was turned into something big and bad."
      end
    end

    describe "page meta_tags is set" do
      it "using an objects meta_tags" do
        object_with_meta_tags = OpenStruct.new(:meta_tags => "blog, taxes, guns, education")

        setup_meta_info(object_with_meta_tags)
        @meta_info[:meta_tags].should == "blog, taxes, guns, education"
      end

      it "uses an objects cleaned up meta_tags" do
        object_with_meta_tags = OpenStruct.new(:meta_tags => "blog, <b>taxes</b>, <em>guns</em>, <i>education</i>")

        setup_meta_info(object_with_meta_tags)
        @meta_info[:meta_tags].should == "blog, taxes, guns, education"
      end
    end
  end

  context "set conversation" do
    it "title as the meta page title" do
      c = FactoryGirl.build(:conversation, :title => "Conversation <b>Title</b>")

      setup_meta_info(c)
      @meta_info[:page_title].should == "Conversation Title"
    end

    it "page_title as the meta page title" do
      c = FactoryGirl.build(:conversation, :title => "Conversation <b>Title</b>", :page_title => "This <b>Rocks</b>!")

      setup_meta_info(c)
      @meta_info[:page_title].should == "This Rocks!"
    end

    it "meta description as the meta page description" do
      c = FactoryGirl.build(:conversation, :meta_description => "Conversation <b>Summary</b>")

      setup_meta_info(c)
      @meta_info[:meta_description].should == "Conversation Summary"
    end
  end

  context "set blog" do
    it "title as the meta page title" do
      c = FactoryGirl.build(:blog_post, :title => "Blog <b>Title</b>")

      setup_meta_info(c)
      @meta_info[:page_title].should == "The Civic Commons Blog: Blog Title"
    end

    it "meta description as the meta page description" do
      c = FactoryGirl.build(:blog_post, :meta_description => "Blog <b>Summary</b>")

      setup_meta_info(c)
      @meta_info[:meta_description].should == "Blog Summary"
    end
  end

  describe "clean and truncate" do
    it "removes extra spaces" do
      c = "   This    is\n\ta   \t test."
      clean_and_truncate(c).should == "This is a test."
    end

    it "removes markup" do
      c = "<b>help</b> me."
      clean_and_truncate(c).should == "help me."
    end

    it "truncates to 15 characters with ellipsis at the end" do
      c = "12345678901234567890"
      clean_and_truncate(c, 15).should == "123456789012..."
    end

  end

  describe "sanitize_meta_values" do
    it "should cleanup the hash value" do
      hash = {'a' => '<b>a</b>', 'b'=> '<b>b</b>'}
      sanitize_meta_values(hash).should == {'a' => 'a', 'b' => 'b'}
    end
  end

end
