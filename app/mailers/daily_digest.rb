class DailyDigest < ApplicationMailer

  def digest(user)
    @user = user
    @questions = Question.last_day.all

    mail to: @user.email, subject: 'Daily digest'
  end
end
