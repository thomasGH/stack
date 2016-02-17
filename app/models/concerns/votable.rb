module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    make_vote(user, 1) if can_up?(user)
  end

  def vote_down(user)
    make_vote(user, -1) if can_down?(user)
  end

  def votes_sum
    votes.sum(:value)
  end

  def can_up?(user)
    is_first_voting?(user) || votes.where({ user_id: user.id, value: -1 }).present?
  end

  def can_down?(user)
    is_first_voting?(user) || votes.where({ user_id: user.id, value: 1 }).present?
  end

  private

  def make_vote(user, value)
    votes.create!(user: user, value: value)
  end

  def is_first_voting?(user)
    votes.where(user_id: user.id).empty?
  end
end