#passed
require 'spec_helper'

describe ManagedIssue do

  context "validations" do

    before(:each) do
      issue = FactoryGirl.create(:managed_issue)
      page = FactoryGirl.create(:managed_issue_page, issue: issue)
      issue.index = page
      issue.save
    end

    it "validates a valid object" do
      FactoryGirl.build(:managed_issue).should be_valid
      FactoryGirl.create(:managed_issue).should be_valid
    end

    context "index page" do

      it "allows a null index_page" do
        FactoryGirl.build(:managed_issue, :index => nil).should be_valid
      end

      it "requires the index page to be a circular reference" do
        issue1 = FactoryGirl.build(:managed_issue, id: 1)
        issue2 = FactoryGirl.build(:managed_issue, id: 2)
        author = FactoryGirl.build(:admin_person)
        page = FactoryGirl.build(:managed_issue_page, :issue => issue2, :author => author)
        issue1.index = page
        issue1.should_not be_valid
      end

      it "limits the index page to be read only" do
        lambda {
          ManagedIssue.first.index.save
        }.should raise_error ActiveRecord::ReadOnlyRecord
      end

    end

    context "pages collection" do

      it "limits the pages collection to be read only" do
        lambda {
          ManagedIssue.first.pages.first.save
        }.should raise_error ActiveRecord::ReadOnlyRecord
      end

      it "destroys all pages when the issue is destroyed" do
        ManagedIssue.first.destroy
        ManagedIssuePage.all.should be_empty
      end

    end

  end

end
