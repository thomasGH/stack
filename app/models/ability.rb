class Ability
  include CanCan::Ability

  attr_accessor :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :manage, [Question, Answer], user_id: user.id
    can :me, User, id: user.id
    can :destroy, Attachment
    can :manage, SubscribersQuestion

    can :make_best, Answer do |answer|
      answer.question.user_id == user.id
    end

    can :vote_up, [Question, Answer] do |obj|
      obj.user_id != user.id && obj.can_up?(user)
    end

    can :vote_down, [Question, Answer] do |obj|
      obj.user_id != user.id && obj.can_down?(user)
    end

    #can :create, [Question, Answer]
    #can :destroy, [Question, Answer], user_id: user.id
  end
end
