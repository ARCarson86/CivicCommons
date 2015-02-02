require 'spec_helper'

describe SearchHelper do

  context "append_ellipsis_if_missing" do
    it "adds an ellipsis to text without a trailing ellipsis" do
      sample_text = "four score and seven years ago, our fathers"

      append_ellipsis_if_missing(sample_text).should == sample_text + "..."
    end

    it "does not add an ellipsis to text with a trailing ellipsis" do
      sample_text = "four score and seven years ago, our fathers..."

      append_ellipsis_if_missing(sample_text).should == sample_text
    end
  end

  context "auto_close_strong_tag" do
    it "closes unclosed strong tags" do
      sample_text = "four score and <strong>seven years ago, our fathers"

      auto_close_strong_tag(sample_text).should == sample_text + "</strong>"
    end

    it "will not close closed strong tags" do
      sample_text = "four <strong>score</strong> and <strong>seven </strong>years ago, our fathers"

      auto_close_strong_tag(sample_text).should == sample_text
    end
  end

  context "text_containing_match" do
    it "trucates at 150 characters and add ellipses" do
      sample_text = "four <strong>score</strong> and <strong>seven </strong>years ago, our fathers brought forth on this continent, a new nation, conceived in Liberty, and dedicated to the proposition that all men are created equal."

      text_containing_match(sample_text).should == "four <strong>score</strong> and <strong>seven </strong>years ago, our fathers brought forth on this continent, a new nation, conceived in Liberty, and..."
    end

    it "does not cut off strong tags" do
      sample_text = "four <strong>score</strong> and <strong>seven </strong>years ago, our fathers brought forth on this continent, a new nation, conceived in <strong>Liberty</strong>, and dedicated to the proposition that all men are created equal."

      text_containing_match(sample_text).should == "four <strong>score</strong> and <strong>seven </strong>years ago, our fathers brought forth on this continent, a new nation, conceived in <strong>Liber</strong>..."
    end

  end

end
