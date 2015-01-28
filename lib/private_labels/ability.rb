module PrivateLabels
  class Ability
    include CanCan::Ability

    def initialize(user)
      user ||= Person.new

      private_label = Swayze.current_private_label

      if user.admin?
        can :manage, Conversation
        can :manage, Contribution
        can :read, Person
        can :update, Person, id: user.id
      elsif private_label.admins.first conditions: { id: user.id }
        can :manage, Conversation, private_label_id: private_label.id
        can :manage, Contribution, conversation: { private_label_id: private_label.id }
        can :read, Person, private_label_people: { private_label_id: private_label.id }
        can :update, Person, id: user.id
      elsif user.persisted?
        can :read, Conversation, private_label_id: private_label.id
        can :read, Contribution, private_label_id: private_label.id
        can [:create, :update], Contribution, { conversation:  { private_label_id: private_label.id }, owner: user.id }
        can :read, Person, id: user.id
        can :update, Person, id: user.id
      else
        can :read, Conversation, private_label_id: private_label.id
        can :read, Contribution, conversation: { private_label_id: private_label.id }
      end
    end
  end
end
