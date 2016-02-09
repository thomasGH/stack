class Question < ActiveRecord::Base
  include Votable
  include Attachable

  belongs_to :user
  has_many :answers, dependent: :destroy
  belongs_to :best_answer, class_name: "Answer"

  validates :title, :body, :user_id, presence: true
  validates :title, uniqueness: true, length: { maximum: 200 }

  scope :last_day, -> { where("created_at >= now() - interval '1 day'") }
end
