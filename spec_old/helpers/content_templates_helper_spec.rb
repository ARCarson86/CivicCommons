require 'spec_helper'

describe ContentTemplatesHelper do

  context "parse_content_template" do

    let(:template) do
      FactoryGirl.create(:content_template)
    end

    it "parses the requested template with the CCML parser" do
      CCML.should_receive(:parse).once.with(anything(), anything())
      parse_content_template(template.id)
    end

    it "looks up a template by the id" do
      parse_content_template(template.id).should == template.template
    end

    it "looks up a template by friendly-id" do
      parse_content_template(template.slug).should == template.template
    end

    it "returns blank when template not found" do
      parse_content_template('does not exist').should be_blank
    end

  end

end
