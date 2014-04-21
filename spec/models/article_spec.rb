require 'spec_helper'

describe Article do
  describe "Validation" do
    it "is valid" do
      @article = FactoryGirl.build(:article)
      @article.should be_valid
    end
  end

  context "paperclip" do
    it "will have necessary db columns for paperclip" do
      should have_db_column(:image_file_name).of_type(:string)
      should have_db_column(:image_content_type).of_type(:string)
      should have_db_column(:image_file_size).of_type(:integer)
    end
    # It is accepting xml and plain text.
    it "should not have validation for content type" do
      should validate_attachment_content_type(:image).
                   allowing('image/png', 'image/gif').
                   rejecting('text/plain', 'text/xml')
    end
    it "should not have default image" do
      Article.attachment_definitions[:image][:default_url].should be_nil
    end
  end

end
