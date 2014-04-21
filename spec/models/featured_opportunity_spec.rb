#passed
require 'spec_helper'

describe FeaturedOpportunity do
  describe "Associations" do
    it { should belong_to :conversation}
    it { should have_and_belong_to_many :contributions}
    it { should have_and_belong_to_many :actions}
    it { should have_and_belong_to_many :reflections}
  end
  describe "Validations" do
    it {should validate_presence_of :conversation_id}
    it {should validate_presence_of :actions}
    it {should validate_presence_of :contributions}
    it {should validate_presence_of :reflections}
  end
end
