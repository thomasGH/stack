class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :votes, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true
  validates :body, uniqueness: true
end
