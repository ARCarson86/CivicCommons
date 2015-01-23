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

    describe '#alert_icon' do
      it { should respond_to :alert_icon }

      it 'returns the proper notice icon' do
        expect(helper.alert_icon(:notice)).to include('icon-ok')
      end
      it 'returns the proper warning icon' do
        expect(helper.alert_icon(:warning)).to include('!')
      end
      it 'returns the proper error icon' do
        expect(helper.alert_icon(:error)).to include('icon-remove')
      end
    end

    describe '#parameterized_model_name' do
      it { should respond_to :parameterized_model_name }
    end
  end
end
