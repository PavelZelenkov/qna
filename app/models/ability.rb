class Ability
  include CanCan::Ability

  attr_reader :user

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

    can :create, [Question, Answer, Comment]

    can [:update, :destroy], [Question, Answer], author: user

    can :destroy, ActiveStorage::Attachment do |attachment|
      attachment.record.present? && attachment.record.author == user
    end
    
    can :destroy, Link do |link|
      link.linkable.present? && link.linkable.author == user
    end
 
    can :like, Answer do |answer|
      answer.author_id != user.id
    end
    can :like, Question do |question|
      question.author_id != user.id
    end

    can :mark_as_best, Answer do |answer|
      answer.question.author == user
    end
  end
end
