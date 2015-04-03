RSpec.shared_examples 'a private label scoped model' do
  describe '.default_scope' do
    it 'returns an active record relation' do
      expect( described_class.default_scope ).to be_a ActiveRecord::Relation
    end

    context 'when a current private label is not set' do
      it 'looks for records with private_label_id set to nil' do
        expect(described_class.default_scope.where_values_hash).to eq({ "private_label_id" => nil })
      end
    end

    context 'when a current private label has been set' do
      let(:private_label)       { create(:private_label) }
      before(:each)             { Swayze.current_private_label = private_label }

      it 'looks for records only for that private label' do
        expect(described_class.default_scope.where_values_hash).to eq({ "private_label_id" => private_label.id })
      end
    end
  end
end
