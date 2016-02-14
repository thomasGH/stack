class CreateSubscribersQuestions < ActiveRecord::Migration
  def change
    create_table :subscribers_questions do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :question, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
