class Answer < ActiveRecord::Base
  include Votable
  include Attachable

  belongs_to :question, touch: true
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true
  validates :body, uniqueness: true
end
