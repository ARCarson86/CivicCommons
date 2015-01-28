require 'rails_helper'

RSpec.describe PrivateLabels::Ability do
  let(:ability) { PrivateLabels::Ability.new(person) }
  let(:private_label) { create :private_label }
  let(:restricted_private_label) { create :private_label }
  let(:conversation) { create(:conversation, private_label: private_label) }
  let(:restricted_conversation) { create(:conversation, private_label: restricted_private_label) }
  let(:contribution) { create(:contribution, conversation: conversation, private_label: private_label) }
  let(:restricted_contribution) { create(:contribution, conversation: restricted_conversation, private_label: private_label) }
  let(:sidebar) { private_label.build_sidebar }
  let(:restricted_sidebar) { restricted_private_label.build_sidebar }

  before(:each) do
    Swayze.current_private_label = private_label
  end

  context 'when person is an admin' do
    let(:person) { create :admin }

    it 'allows them to manage the current private label' do
      expect(ability.can? :manage, private_label).to be_truthy
    end

    it 'allows them to manage a conversation for the current private label' do
      expect(ability.can? :manage, conversation).to be_truthy
    end

    it 'allows them to manage a conversation for another private label' do
      expect(ability.can? :manage, restricted_conversation).to be_truthy
    end

    it 'allows them to manage a contribution for the current private label' do
      expect(ability.can? :manage, contribution).to be_truthy
    end

    it 'allows them to manage a contribution for a different private label' do
      expect(ability.can? :manage, restricted_contribution).to be_truthy
    end

    it 'allows them to manage the sidebar' do
      expect(ability.can?(:manage, sidebar)).to be_truthy
    end

    it 'does not allow them to manage the sidebar of a different private label' do
      expect(ability.can?(:manage, restricted_sidebar)).to be_falsey
    end

  end

  context 'when person is an administrator of the current private label' do
    let(:person) { create :person }

    before(:each) do
      create :private_label_person, person: person, private_label: private_label, admin: true
    end

    it 'allows them to manage the current private label' do
      expect(ability.can? :manage, private_label).to be_truthy
    end

    it 'allows them to manage the conversation for the current private label' do
      expect(ability.can? :manage, conversation).to be_truthy
    end

    it 'doesn\'t allow them to manage the conversation for another private label' do
      expect(ability.can? :manage, restricted_conversation).to be_falsey
    end

    it 'allows them to manage a contribution for the current private label' do
      expect(ability.can? :manage, contribution).to be_truthy
    end

    it 'does not allow them to manage a contribution for a different private label' do
      expect(ability.can? :manage, restricted_contribution).to be_falsey
    end

    it 'allows them to manage the sidebar' do
      expect(ability.can?(:manage, sidebar)).to be_truthy
    end

    it 'does not allow them to manage the sidebar of a different private label' do
      expect(ability.can?(:manage, restricted_sidebar)).to be_falsey
    end

  end

  context 'when a person is not an administrator' do
    context 'and the user has registered for the current private label' do
      let (:person) { create :person }
      let (:updatable_contribution) { create :contribution, person: person, conversation: conversation }

      before(:each) do
        create :private_label_person, person: person, private_label: private_label
      end

      it 'allows them to read any conversation' do
        expect(ability.can?(:read, conversation)).to be_truthy
      end

      it 'does not allow them to manage the current private label' do
        expect(ability.can?(:manage, private_label)).to be_falsey
      end

      it 'does not allow them to read any conversation' do
        expect(ability.can?(:read, restricted_conversation)).to be_falsey
      end

      it 'does not allow creation of a conversation' do
        expect(ability.can?(:create, Conversation)).to be_falsey
      end

      it 'does not allow management of conversation' do
        expect(ability.can?(:update, conversation)).to be_falsey
        expect(ability.can?(:delete, conversation)).to be_falsey
      end

      it 'does not allow management of conversation in another private label' do
        expect(ability.can?(:update, restricted_conversation)).to be_falsey
        expect(ability.can?(:delete, restricted_conversation)).to be_falsey
      end

      it 'allows them to create a contribution' do
        expect(ability.can?(:create, Contribution.new(conversation: conversation, person: person))).to be_truthy
      end

      it 'allows them to create a contribution' do
        expect(ability.can?(:create, Contribution.new(conversation: restricted_conversation, person: person))).to be_falsey
      end

      it 'allows them to update their own contribution' do
        expect(ability.can?(:update, updatable_contribution)).to be_truthy
      end

      it 'does not allow them to update someone else\'s own contribution' do
        expect(ability.can?(:update, contribution)).to be_falsey
      end

    end

    context 'when anonymous' do
      let(:person) { nil }

      it 'allows them to read a conversation' do
        expect(ability.can?(:read, conversation)).to be_truthy
      end

      it 'does not allow them to manage the current private label' do
        expect(ability.can?(:manage, private_label)).to be_falsey
      end

      it 'does not allow them to read a conversation from another private label' do
        expect(ability.can?(:read, restricted_conversation)).to be_falsey
      end

      it 'allows them to read a contribution' do
        expect(ability.can?(:read, contribution)).to be_truthy
      end

      it 'does not allow them to read a contribution from another private label' do
        expect(ability.can?(:read, restricted_conversation)).to be_falsey
      end

      it 'does not allow them to create a contribution' do
        expect(ability.can?(:create, Contribution)).to be_falsey
      end

    end

  end


end
