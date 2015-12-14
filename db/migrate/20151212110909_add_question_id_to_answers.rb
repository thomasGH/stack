class AddQuestionIdToAnswers < ActiveRecord::Migration
  def change
    add_belongs_to :answers, :question, index: true
  end
end
