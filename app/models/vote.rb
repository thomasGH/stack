class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :answer

  validates :user_id, :answer_id, presence: true
end
