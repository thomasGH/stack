class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    @question = Question.find(params[:id])
    render json: @question
  end

  # Don'w work :( ActionController::InvalidAuthenticityToken
  #
  # def create
  #   @question = Question.new(params.require(:question).permit(:title, :body))
  #   @question.user = current_resource_owner.id

  #   if @question.save
  #     render json, nothing: true, status: 200
  #   else
  #     render json: @question.errors.full_messages, status: :unprocessable_entity
  #   end
  # end
end