class SearchController < ApplicationController
  def search
    query = Riddle::Query.escape(params[:q])

    if params[:where] == 'Question' || params[:where] == 'Answer'
      @results = ThinkingSphinx.search query, classes: [params[:where].constantize]
    else
      @results = ThinkingSphinx.search query
    end
  end
end
