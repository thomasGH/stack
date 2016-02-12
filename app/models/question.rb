class Question < ActiveRecord::Base
  include Votable
  include Attachable

  belongs_to :user
  has_many :answers, dependent: :destroy
  belongs_to :best_answer, class_name: "Answer"

  validates :title, :body, :user_id, presence: true
  validates :title, uniqueness: true, length: { maximum: 200 }

  default_scope { order(:id) }

  scope :last_day, -> { where("created_at >= now() - interval '1 day'") }

  def make_best(answer)
    self.class.transaction do
      # some actions for one transaction...
      update!(best_answer: answer) if self.answers.include?(answer)
    end
  end
end
