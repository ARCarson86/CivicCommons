require 'rails_helper'

RSpec.describe Swayze do
  let(:domain)            { Faker::Internet.domain_name }
  let(:swayze)            { Swayze.new({ domain: domain }) }

  before(:each) do
    @private_label = create(:private_label, domain: domain)
    @another_private_label = create(:private_label) 
  end

  describe '#initialize' do
    context 'when there is no private label that matches the conditions' do
      it 'raises an ActiveRecord::RecordNotFound error' do
        expect{ Swayze.new({ domain: "not_there" }) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#contributions' do
    let(:results)           { swayze.contributions }

    before(:each) do
      allow_any_instance_of(Paperclip::Attachment).to receive(:save).and_return(true)

      @contribution = create(:contribution, private_label: @private_label)
      @another_contribution = create(:contribution, private_label: @another_private_label) 
      @civic_contribution = create(:contribution)
    end

    it 'returns an active record relation' do
      expect(results).to be_an ActiveRecord::Relation
    end

    it 'includes contributions for the private label' do
      expect(results).to include(@contribution)
    end

    it 'does not include contributions from another private label' do
      expect(results).not_to include(@another_contribution)
    end

    it 'does not include Civic Commons contributions' do
      expect(results).not_to include(@civic_contribution)
    end
  end

  describe '#conversations' do
    let(:results)       { swayze.conversations }

    before(:each) do
      @conversation = create(:conversation, private_label: @private_label)
      @another_conversation = create(:conversation, private_label: @another_private_label)
      @civic_conversation = create(:conversation)
    end

    it 'returns an active record relation' do
      expect(results).to be_an ActiveRecord::Relation
    end

    it 'includes conversations for the private label' do
      expect(results).to include(@conversation)
    end

    it 'does not include conversations from other private labels' do
      expect(results).not_to include(@another_conversation)
    end

    it 'does not include Civic Commons conversations' do
      expect(results).not_to include(@civic_conversation)
    end
  end

  describe '#admins' do
    let(:results)     { swayze.admins }

    before(:each) do
      @non_admin = create(:person)
      create(:private_label_person, person: @non_admin, private_label: @private_label) 

      @admin = create(:person)
      create(:private_label_person, person: @admin, private_label: @private_label, admin: true)

      @other_admin = create(:person)
      create(:private_label_person, person: @other_admin, private_label: @another_private_label, admin: true)
    end

    it 'returns an array ' do
      expect(results).to be_an Array
    end

    it 'includes the admins for the private label' do
      expect(results).to include(@admin)
    end

    it 'does not include non admins' do
      expect(results).not_to include(@non_admin)
    end

    it 'does not include admins for other private labels' do
      expect(results).not_to include(@other_admin)
    end
  end
end
