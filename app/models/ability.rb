class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role == Role::GUEST
      can :read, User
      can :read, Epic
    elsif user.role == Role::USER
      can :read, User
      can :update, User, id: user.id
      can :create, User do |u|
        u.role != Role::ADMIN
      end
      can :read, Epic
    elsif user.role == Role::ADMIN
      can :manage, :all
    end
  end
end
