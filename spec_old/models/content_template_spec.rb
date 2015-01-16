# passing
require 'spec_helper'

describe ContentTemplate do
  
  before(:all) do
    @author = FactoryGirl.build(:admin_person)
  end

  before(:each) do
    @attr = FactoryGirl.attributes_for(:content_template)
    @attr[:author] = @author
  end

  context "validations" do

    it "creates a valid object" do
      ContentTemplate.new(@attr).should be_valid
    end

    it "validates the presence of name" do
      @attr.delete(:name)
      ContentTemplate.new(@attr).should_not be_valid
    end

    it "validates the presence of template" do
      @attr.delete(:template)
      ContentTemplate.new(@attr).should_not be_valid
    end

    it "validates the presence of author" do
      @attr.delete(:author)
      ContentTemplate.new(@attr).should_not be_valid
    end

    it "validates the uniqueness of the name" do
      ContentTemplate.new(@attr).save
      @attr[:template] = 'new stuff'
      @attr[:slug] = 'new_stuff'
      @attr[:author] = FactoryGirl.build(:admin_person, :id => @author.id+1)
      ContentTemplate.new(@attr).should_not be_valid
    end

  end

end
