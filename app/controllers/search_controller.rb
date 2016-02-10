class SearchController < ApplicationController
  def search
    query = Riddle::Query.escape(params[:q])

    case params[:where]
    when 'Questions'
      @results = Question.search query
    when 'Answers'
      @results = Answer.search query
    else
      @results = ThinkingSphinx.search query, classes: [Question, Answer]
    end
  end
end
