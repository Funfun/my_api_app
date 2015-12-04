class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role == Role::GUEST
      can :read, User
      can :read, Epic
      can :read, Story
    elsif user.role == Role::USER
      can :read, Story
      can :read, User
      can :update, User, id: user.id
      can :create, Story do |u|
        u.role != Role::ADMIN
      end
      can :update, Story, user_id: user.id
      can :create, User do |u|
        u.role != Role::ADMIN
      end
      can :read, Epic
      can :destroy, Story, user_id: user.id
    elsif user.role == Role::ADMIN
      can :manage, :all
    end
  end
end
