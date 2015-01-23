module PrivateLabels
  class Ability
    include CanCan::Ability

    def initialize(user, swayze)
      user ||= Person.new
      private_label_id = swayze.private_label_id

      if swayze.admins.first conditions: { id: user.id } or user.admin?
        can :manage, Conversation, private_label_id: private_label_id
        can :manage, Contribution, private_label_id: private_label_id
      elsif user.persisted?
        can :read, Conversation, private_label_id: private_label_id
        can :read, Contribution, private_label_id: private_label_id
        can [:create, :update], Contribution, { private_label_id: private_label_id, owner: user.id }
      else
        can :read, Conversation, private_label_id: swayze.private_label_id
      end
    end
  end
end
