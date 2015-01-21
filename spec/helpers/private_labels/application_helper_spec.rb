require 'rails_helper'

module PrivateLabels
  RSpec.describe ApplicationHelper do
    subject { helper }

    describe '#content_area_column_width_class' do
      it { should respond_to :content_area_column_width_class }
    end

    describe '#page_classes' do
      it { should respond_to :page_classes }
    end
  end
end
