require 'spec_helper'

describe Mime::Type do
  describe ".parse" do

    # Test for rails issue:
    #   https://github.com/rails/rails/issues/736
    #
    # This issue exists in Rails 3.0.7 and we have a monkey patch for it in:
    #    config/initializers/rails_issue_736.rb
    #
    # If this test is failing, it is likely because an upgrade to rails
    # disables the monkey patch, but Rails hasn't fixed the problem yet.
    #
    it "should correctly handle media range in Accepts header when single type is specified" do
      Mime::Type.parse("*/*;q=0.9").should == [Mime::ALL]
      Mime::Type.parse("text/html;q=0.9").should == [Mime::HTML]
    end
    
    # Test for rails issue:
    #   https://github.com/rails/rails/issues/860
    #
    # This issue exists in Rails 3.0.7 and we have a monkey patch for it in:
    #   config/initializers/rails_issue_860.rb
    #
    # If this test is failing, it is likely because an upgrade to rails
    # disables the monkey patch, but Rails hasn't fixed the problem yet.
    #
    it "should correctly match prefix/* types" do
      actual_types   = Mime::Type.parse("text/*").sort_by(&:to_s)
      expected_types = Mime::SET.select{|t| t =~ 'text'}.sort_by(&:to_s)
      actual_types.should == expected_types

      actual_types   = Mime::Type.parse("application/*").sort_by(&:to_s)
      expected_types = Mime::SET.select{|t| t =~ 'application'}.sort_by(&:to_s)
      actual_types.should == expected_types

      actual_types   = Mime::Type.parse("image/*").sort_by(&:to_s)
      expected_types = Mime::SET.select{|t| t =~ 'image'}.sort_by(&:to_s)
      actual_types.should == expected_types
    end
  end
end