require 'rails_helper'

RSpec.describe PrivateLabels::Sidebar, :type => :model do
  it { should belong_to(:private_label) }

  describe '.table_name' do
    it 'should be correct' do
      expect(subject.class.table_name).to eq("private_labels_sidebars")
    end
  end
end
