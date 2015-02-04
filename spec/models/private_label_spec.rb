require 'rails_helper'

describe PrivateLabel, :type => :model do
  it { should have_one(:sidebar).class_name('PrivateLabels::Sidebar') }

  let(:private_label)   { FactoryGirl.create :private_label }
  let(:admin)           { FactoryGirl.create :person }

  describe 'validation' do
    it { should validate_inclusion_of(:theme).in_array(PrivateLabel::THEMES).allow_nil }
  end

  describe "add_admin" do
    it "adds a person as a private label administrator" do
      private_label.add_admin admin
      expect(private_label.reload.admins).to include(admin)
    end
  end
end
