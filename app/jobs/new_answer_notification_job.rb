class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer_id)
    answer   = Answer.find(answer_id)
    question = answer.question

    recipients = []

    recipients << question.author if question.author != answer.author

    subscribers = question.subscribers.where.not(id: answer.author_id)
    recipients.concat(subscribers)

    recipients.uniq.each do |user|
      NotificationsMailer.new_answer(user, answer).deliver_later
    end
  end
end
