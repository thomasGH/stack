class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_answer, only: [:show, :edit, :update, :destroy]
  before_action :set_question, only: [:create, :update, :new] # 'new' will be remove after move answer's form to show question page

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if current_user.author_of?(@answer)
      if @answer.update(answer_params)
        redirect_to @question, notice: 'Your answer successfully updated'
      else
        render :edit
      end
    else
      redirect_to @question
    end
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
    redirect_to questions_path
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
