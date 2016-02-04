class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_answer, only: [:show, :edit, :update, :destroy, :make_best]

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      PrivatePub.publish_to "/questions/#{@answer.question_id}/answers", response: { answer: @answer, email: current_user.email }
      render json: { answer: @answer, email: @answer.user.email, attachments: @answer.attachments }
    else
      render json: @answer.errors.full_messages, status: :unprocessable_entity 
    end
  end

  def edit
  end

  def update
    if @answer.update(answer_params)
      render json: { answer: @answer, email: @answer.user.email }
    else
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy
    render json: @answer
  end

  def make_best
    question = @answer.question
    question.best_answer_id = @answer.id

    if question.save
      render json: @answer
    else
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
