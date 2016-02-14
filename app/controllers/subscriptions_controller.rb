class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource :class => 'SubscribersQuestion'

  def create
    @question = Question.find(params[:question_id])
    current_user.subscribe_to(@question)
    render json: { question: @question, state: 'subscribed'}
  end

  def destroy
    @question = Question.find(params[:id])
    current_user.unsubscribe_from(@question)
    render json: { question: @question, state: 'unsubscribed'}
  end
end
