module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:vote_up, :vote_down]
  end

  def vote_up
    @votable.vote_up(current_user)
    render json: { votes: @votable.votes_sum, object_id: @votable.id }
  end

  def vote_down
    @votable.vote_down(current_user)
    render json: { votes: @votable.votes_sum, object_id: @votable.id }
  end

  private

  def load_votable
    klass = params[:controller].singularize.classify.constantize
    @votable = klass.find(params[:id])
  end
end