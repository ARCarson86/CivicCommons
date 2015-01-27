require 'rails_helper'

RSpec.describe Person do
  it { should have_many(:private_label_people).dependent(:destroy) }
  it { should have_many(:private_labels).through(:private_label_people) }
  it { should accept_nested_attributes_for(:private_label_people) }
end
