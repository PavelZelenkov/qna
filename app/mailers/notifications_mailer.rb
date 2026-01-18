class NotificationsMailer < ApplicationMailer
  default from: "no-reply@example.com"

  def daily_digest(user, questions)
    @user = user
    @questions = questions
    mail to: @user.email, subject: "Daily Question Digest"
  end

  def new_answer(user, answer)
    @user = user
    @answer = answer
    @question = question
    mail to: @user.email, subject: "New Answer: #{@question.title}"
  end
end
