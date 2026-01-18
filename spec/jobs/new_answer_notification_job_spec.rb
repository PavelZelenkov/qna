require "rails_helper"

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:author)     { create(:user) }
  let(:subscriber) { create(:user) }
  let(:answerer)   { create(:user) }
  let(:question)   { create(:question, author: author) }
  let(:answer)     { create(:answer, question: question, author: answerer) }

  before do
    create(:subscription, user: subscriber, question: question)
  end

  it "sends emails to author and subscribers (excluding answer author)" do
    mail_double = double("mail", deliver_later: true)

    expect(NotificationsMailer).to receive(:new_answer)
      .with(author, answer).and_return(mail_double)

    expect(NotificationsMailer).to receive(:new_answer)
      .with(subscriber, answer).and_return(mail_double)

    expect(NotificationsMailer).not_to receive(:new_answer)
      .with(answerer, answer)

    described_class.perform_now(answer.id)
  end
end
