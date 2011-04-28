require 'spec_helper'

describe ManagedIssue do

  context "validations" do

    let(:attributes) {
      Factory.attributes_for(:managed_issue)
    }

    it "validates a valid object" do
      ManagedIssue.new(attributes).should be_valid
    end

    it "allows a null index_page" do
      attributes.delete(:index_page)
      ManagedIssue.new(attributes).should be_valid
    end

    it "requires the index page to be a circular reference" do
      issue1 = Factory.build(:managed_issue, id: 1)
      issue2 = Factory.build(:managed_issue, id: 2)
      author = Factory.build(:admin_person)
      page = Factory.build(:managed_issue_page, :issue => issue2, :author => author)
      issue1.index = page
      issue1.should_not be_valid
    end

    context "associations" do

      before(:each) do
        issue = Factory.create(:managed_issue)
        page = Factory.create(:managed_issue_page, issue: issue)
        issue.index = page
        issue.save
      end

      it "limits the index page to be read only" do
        lambda {
          ManagedIssue.first.index.save
        }.should raise_error ActiveRecord::ReadOnlyRecord
      end

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
