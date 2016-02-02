class Answer < ActiveRecord::Base
  include Votable
  include Attachable

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true
  validates :body, uniqueness: true

  accepts_nested_attributes_for :attachments
end
