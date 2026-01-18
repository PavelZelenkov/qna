class Services::DailyDigest
  def send_digest
    questions = Question.where("created_at >= ?", 1.day.ago)

    User.find_each(batch_size: 500) do |user|
      NotificationsMailer.daily_digest(user, questions).deliver_now
    end
  end
end
