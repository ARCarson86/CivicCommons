require 'rails_helper'

module PrivateLabels
  RSpec.describe ApplicationHelper do
    subject { helper }

    describe '#content_area_column_width_class' do
      it { should respond_to :content_area_column_width_class }
    end

    describe '#page_classes' do
      let(:controller_name)           { 'conversations_controller' }
      let(:params)                    { { controller: controller_name } }
      before(:each)                   { allow(helper).to receive(:params).and_return(params) }

      it 'returns a string' do
        expect(helper.page_classes).to be_a String
      end

      context 'with a non-admin controller' do
        let(:controller_name)       { 'conversations_controller' }

        it 'returns the name of the controller' do
          expect(helper.page_classes).to eq('conversations_controller')
        end
      end

      context 'with a namespaced controller' do
        let(:controller_name)       { 'private_labels/conversations_controller' }

        it 'returns the name of the controller replacing / with -' do
          expect(helper.page_classes).to match(/\sprivate_labels-conversations_controller/)
        end

        it 'adds a separate class for the namespace' do
          expect(helper.page_classes).to match(/private_labels\s/)
        end

        context 'and more than one namespace' do
          let(:controller_name)     { 'private_labels/admin/conversations_controller' }

          it 'adds a separate class for each namespace' do
            expect(helper.page_classes).to match(/private_labels\s/)
            expect(helper.page_classes).to match(/admin\s/)
          end

          it 'returns the name of the controller replacing / with -' do
            expect(helper.page_classes).to match(/\sprivate_labels-admin-conversations_controller/)
          end
        end
      end

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
