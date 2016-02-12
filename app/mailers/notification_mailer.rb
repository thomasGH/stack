class NotificationMailer < ApplicationMailer
  def answer_notification(user, question, answer)
    @user = user
    @question = question
    @answer = answer

    mail(to: user.email, subject: 'Новый ответ на вопрос')
  end
end