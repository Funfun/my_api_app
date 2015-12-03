class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role == Role::GUEST
      can :read, User
    elsif user.role == Role::USER
      can [:read, :create], User do |u|
        puts u.role
        u.role != Role::ADMIN
      end
    elsif user.role == Role::ADMIN
      can :manage, User
    end
  end
end
