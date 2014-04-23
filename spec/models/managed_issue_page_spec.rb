#passed
require 'spec_helper'

describe ManagedIssuePage do
  
  before(:all) do
    @author = FactoryGirl.build(:admin_person)
    @issue = FactoryGirl.build(:managed_issue)
  end

  before(:each) do        
    @attr = FactoryGirl.attributes_for(:managed_issue_page)
    @attr[:issue] = @issue
    @attr[:author] = @author
  end

  context "validations" do

    it "creates a valid object" do
      ManagedIssuePage.new(@attr).should be_valid
    end

    it "validates the presence of name" do
      @attr.delete(:name)
      ManagedIssuePage.new(@attr).should_not be_valid
    end

    it "validates the presence of template" do
      @attr.delete(:template)
      ManagedIssuePage.new(@attr).should_not be_valid
    end

    it "validates the presence of issue" do
      @attr.delete(:issue)
      ManagedIssuePage.new(@attr).should_not be_valid
    end

    it "validates that the issue is a managed issue" do
      @attr[:issue] = FactoryGirl.build(:issue)
      lambda { ManagedIssuePage.new(@attr) }.should raise_error
    end

    it "validates the presence of author" do
      @attr.delete(:author)
      ManagedIssuePage.new(@attr).should_not be_valid
    end

    it "validates the uniqueness of the name" do
      ManagedIssuePage.new(@attr).save
      @attr[:template] = 'new stuff'
      @attr[:slug] = 'new_stuff'
      @attr[:author] = FactoryGirl.build(:admin_person, :id => @author.id+1)
      ManagedIssuePage.new(@attr).should_not be_valid
    end
    
    describe "validation of ccml tags" do
      it "should error out if there is a ccml tag that is not valid" do
        template = %q[{ccml:rss:items  limit="6" refresh="30"}<p><b><a href="{link}">{title}</a></b> ({date format='%m-%d-%Y %I:%M %p'})<br />{description}</p>{/ccml:rss:items}]
        managed_issue_page = FactoryGirl.build(:managed_issue_page,:template => template)
        managed_issue_page.should_not be_valid
        managed_issue_page.errors[:template].should ==["has a CCML tag error: RSS feed url:  is not valid."]
      end
      it "should not error out if there is no problem with ccml" do
        template = %q[{ccml:route:url route="issues"}]
        managed_issue_page = FactoryGirl.build(:managed_issue_page,:template => template)
        managed_issue_page.should be_valid
      end
    end

  end

end
