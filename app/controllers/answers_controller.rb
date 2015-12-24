class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_answer, only: [:show, :edit, :update, :destroy]
  before_action :set_question, only: [:create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      PrivatePub.publish_to "/questions/#{@answer.question_id}/answers", response: response
      render json: @answer
    else
      render json: @answer.errors.full_messages, status: :unprocessable_entity 
    end
  end

  def edit
  end

  def update
    if current_user.author_of?(@answer)
      if @answer.update(answer_params)
        render json: @answer
      else
        render json: @answer.errors.full_messages, status: :unprocessable_entity
      end
    else
      head :forbiden
    end
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
    render json: @answer
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
