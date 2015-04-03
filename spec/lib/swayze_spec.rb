require 'rails_helper'

RSpec.describe Swayze do
  describe '.current_private_label' do
    context 'when one has not been set' do
      it 'returns nil' do
        expect(Swayze.current_private_label).to be_nil
      end
    end

    context 'when a private label has been set' do
      let(:private_label) { build(:private_label) }

      before(:each) do
        allow(Thread.current).to receive(:[]).and_call_original
        expect(Thread.current).to receive(:[]).with(:current_private_label).and_return(private_label)
      end

      it 'returns the private label object' do
        expect(Swayze.current_private_label).to be(private_label)
      end
    end
  end

  describe '.current_private_label=' do
    context 'when the value is nil' do
      it 'does not raise an error' do
        expect { Swayze.current_private_label = nil }.not_to raise_error
      end
    end

    context 'when a value is passed in' do
      let(:private_label)     { build(:private_label) }

      it 'stores it in the thread' do
        Swayze.current_private_label = private_label
        expect(Thread.current[:current_private_label]).to be(private_label)
      end
    end

    context "when one thread sets a value and another does not" do
      it 'sets the value in the second thread only' do
        Thread.start do
          Swayze.current_private_label = private_label
          Thread.start do
            expect(Swayze.current_private_label).to be_nil
          end
          expect(Swayze.current_private_label).to be private_label
        end
      end
    end
  end

  describe '.civic_commons?' do
    context 'when a current private label has not been set' do
      it 'returns true' do
        expect(Swayze.civic_commons?).to be_truthy
      end
    end

    context 'when a current private label has been set' do
      let(:private_label)     { build(:private_label) }
      before(:each)           { Swayze.current_private_label = private_label }

      it 'returns false' do
        expect(Swayze.civic_commons?).to be_falsey
      end
    end
  end

  describe '.private_label?' do
    context 'when no current private label has been set' do
      it 'returns false' do
        expect(Swayze.private_label?).to be_falsey
      end
    end

    context 'when a private label has been set' do
      let(:private_label)   { build(:private_label) }
      before(:each)         { Swayze.current_private_label = private_label }

      it 'returns true' do
        expect(Swayze.private_label?).to be_truthy
      end
    end
  end

  describe '.people' do
    let(:private_label)                 { create(:private_label) }
    let(:private_label_2)               { create(:private_label) }
    let(:private_label_person)          { create(:person) }
    let(:private_label_2_person)        { create(:person) }
    let(:civic_person)                  { create(:person) }
    let(:results)                       { Swayze.people }

    before(:each) do
      private_label.people << private_label_person
      private_label_2.people << private_label_2_person
    end

    context 'when a current private label has not been set' do
      it 'returns an ActiveRecord::Relation' do
        expect(results).to be_an ActiveRecord::Relation
      end

      it 'includes people not associated with any private label' do
        expect(results).to include(civic_person)
      end

      it 'includes people associated with private labels' do
        expect(results).to include(private_label_person)
        expect(results).to include(private_label_2_person)
      end
    end

    context 'when a current private label is set' do
      before(:each)                 { Swayze.current_private_label = private_label }

      it 'returns an ActiveRecord::Relation' do
        expect(results).to respond_to(:proxy_association)
      end

      it 'includes people directly associated with the current private label' do
        expect(results).to include(private_label_person)
      end

      it 'does not include people not associated with any private label' do
        expect(results).not_to include(civic_person)
      end

      it 'does not include people associated with another private label' do
        expect(results).not_to include(private_label_2_person)
      end
    end
  end

end
