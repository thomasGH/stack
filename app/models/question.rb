class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy
  belongs_to :best_answer, class_name: "Answer"

  validates :title, :body, :user_id, presence: true
  validates :title, uniqueness: true, length: { maximum: 200 }
end
