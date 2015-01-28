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
end
