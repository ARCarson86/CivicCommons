require 'rails_helper'
require 'support/private_label_ability_shared_examples'

RSpec.describe PrivateLabels::Ability do
  let(:ability)                  { PrivateLabels::Ability.new(person) }
  let(:private_label)            { create :private_label }
  let(:restricted_private_label) { create :private_label }
  let(:conversation)             { create(:conversation, private_label: private_label) }
  let(:restricted_conversation)  { create(:conversation, private_label: restricted_private_label) }
  let(:contribution)             { create(:contribution, contributable: conversation, private_label: private_label) }
  let(:restricted_contribution)  { create(:contribution, contributable: restricted_conversation, private_label: private_label) }
  let(:other_person)             { create(:confirmed_person) }
  let(:sidebar)                  { private_label.build_sidebar }
  let(:restricted_sidebar)       { restricted_private_label.build_sidebar }
  let(:page)                     { private_label.pages.build }
  let(:restricted_page)          { restricted_private_label.pages.build }

  before(:each) do
    Swayze.current_private_label = private_label
  end

  context 'when person is an admin' do
    let(:person) { create :admin }

    it_behaves_like 'it allows editing their own account'

    it 'allows them to manage the current private label' do
      expect(ability.can? :manage, private_label).to be_truthy
    end

    it 'allows them to manage a conversation for the current private label' do
      expect(ability.can? :manage, conversation).to be_truthy
    end

    it 'does not allow them to manage a conversation for another private label' do
      expect(ability.can? :manage, restricted_conversation).to be_falsey
    end

    it 'allows them to manage a contribution for the current private label' do
      expect(ability.can? :manage, contribution).to be_truthy
    end

    it 'does not allow them to manage a contribution for a different private label' do
      expect(ability.can? :manage, restricted_contribution).to be_falsey
    end

    it 'allows them to read another person' do
      expect(ability.can? :read, other_person).to be_truthy
    end

    it 'allows them to manage the sidebar' do
      expect(ability.can?(:manage, sidebar)).to be_truthy
    end

    it 'does not allow them to manage the sidebar of a different private label' do
      expect(ability.can?(:manage, restricted_sidebar)).to be_falsey
    end

    it 'allows them to manage PrivateLabelPerson records' do
      expect(ability.can?(:manage, PrivateLabelPerson)).to be_truthy
    end

    it 'allows them to manage a page' do
      expect(ability.can?(:manage, page)).to be_truthy
    end

    it 'does not allow them to manage a page of a different private label' do
      expect(ability.can?(:manage, restricted_page)).to be_falsey
    end

  end

  context 'when person is an administrator of the current private label' do
    let(:person)                { create :person }
    let(:restricted_person)     { create(:confirmed_person) }

    before(:each) do
      @admin_private_label_person = create :private_label_person, person: person, private_label: private_label, admin: true
      @restricted_private_label_person = create :private_label_person, person: restricted_person, private_label: restricted_private_label
      @private_label_person = create :private_label_person, person: other_person, private_label: private_label
    end

    it_behaves_like 'it allows editing their own account'

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

    it 'allows them to read another person associated with the private label' do
      expect(ability.can? :read, other_person).to be_truthy
    end

    it 'does not allow them to read a person not associated with the private label' do
      expect(ability.can? :read, restricted_person).to be_falsey
    end

    it 'allows them to manage the sidebar' do
      expect(ability.can?(:manage, sidebar)).to be_truthy
    end

    it 'does not allow them to manage the sidebar of a different private label' do
      expect(ability.can?(:manage, restricted_sidebar)).to be_falsey
    end

    it 'allows them to manage their own association with the private label' do
      expect(ability.can?(:manage, @admin_private_label_person)).to be_truthy
    end

    it 'allows them to manage the association with the private label for other people' do
      expect(ability.can?(:manage, @private_label_person)).to be_truthy
    end

    it 'does not allow them to manage the association to another private label' do
      expect(ability.can?(:manage, @restricted_private_label_person)).to be_falsey
    end
  end

  context 'when a person is not an administrator' do
    context 'and the user has registered for the current private label' do
      let (:person) { create :person }
      let (:updatable_contribution) { create :contribution, person: person, contributable: conversation }

      before(:each) do
        @private_label_person = create :private_label_person, person: person, private_label: private_label
      end

      it_behaves_like 'it allows editing their own account' 

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
        expect(ability.can?(:create, Contribution.new(contributable: conversation, person: person))).to be_truthy
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

      it 'does not allow the user to view associations with the private label' do
        expect(ability.can?(:read, @private_label_person)).to be_falsey
      end

      it 'allows them to read a page' do
        expect(ability.can?(:read, page)).to be_truthy
      end

      it 'does not allow them to read a page of a different private label' do
        expect(ability.can?(:read, restricted_page)).to be_falsey
      end

      it 'does not allow them to manage a page' do
        expect(ability.can?(:manage, page)).to be_falsey
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

      it 'allows them to read a page' do
        expect(ability.can?(:read, page)).to be_truthy
      end

      it 'does not allow them to read a page of a different private label' do
        expect(ability.can?(:read, restricted_page)).to be_falsey
      end

      it 'does not allow them to manage a page' do
        expect(ability.can?(:manage, page)).to be_falsey
      end

    end

  end


end
