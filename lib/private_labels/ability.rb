module PrivateLabels
  class Ability
    include CanCan::Ability

    def initialize(user)
      user ||= Person.new

      private_label = Swayze.current_private_label

      if user.admin?
        can :manage, PrivateLabel
        can :manage, ConversationsPerson
        can :manage, Conversation, private_label_id: private_label.id
        can :manage, Contribution, conversation: { private_label_id: private_label.id }
        can :read, Person
        can :update, Person, id: user.id
        can :manage, PrivateLabels::Sidebar, private_label: private_label
        can :manage, PrivateLabelPerson
        can :manage, PrivateLabels::Page, private_label_id: private_label.id
      elsif private_label.admins.first conditions: { id: user.id }
        can :manage, PrivateLabel, id: private_label.id
        can :manage, Conversation, private_label_id: private_label.id
        can :manage, Contribution, conversation: { private_label_id: private_label.id }
        can :read, Person, private_label_people: { private_label_id: private_label.id }
        can :update, Person, id: user.id
        can :manage, PrivateLabels::Sidebar, private_label: private_label
        can :manage, PrivateLabelPerson, private_label_id: private_label.id
        can :manage, PrivateLabels::Page, private_label_id: private_label.id
      elsif user.persisted?
        can :read, Conversation, private_label_id: private_label.id
        can :read, Contribution, private_label_id: private_label.id
        can [:create, :update], Contribution, { conversation:  { private_label_id: private_label.id }, owner: user.id }
        can :read, Person, id: user.id
        can :update, Person, id: user.id
        can :read, PrivateLabels::Page, private_label_id: private_label.id
      else
        can :read, Conversation, private_label_id: private_label.id
        can :read, Contribution, conversation: { private_label_id: private_label.id }
        can :read, PrivateLabels::Page, private_label_id: private_label.id
      end
    end
  end
end
