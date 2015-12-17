class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_question, only: [:create, :new] # 'new' will be remove after move answer's form to show question page

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created'
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
