class Answer < ActiveRecord::Base
  include Votable
  include Attachable

  belongs_to :question, touch: true
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true
  validates :body, uniqueness: true

  after_create :send_notification

  private

  def send_notification
    NotificationMailer.answer_notification(question.user, question, self).deliver_now

    question.subscribers.find_each do |user|
      NotificationMailer.answer_notification(user, question, self).deliver_now
    end
  end
end
