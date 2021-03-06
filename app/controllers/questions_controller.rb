class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  authorize_resource

  include Voted

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      PrivatePub.publish_to "/questions", response: { question: @question, email: current_user.email }
      redirect_to questions_path, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      render json: @question
    else
      render json: @question.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
