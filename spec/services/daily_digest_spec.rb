require "rails_helper"

RSpec.describe Services::DailyDigest do
  let!(:users) { create_list(:user, 3) }

  let!(:old_question) { create(:question, created_at: 2.days.ago) }
  let!(:new_question) { create(:question, created_at: 5.hours.ago) }

  it "sends daily digest to all users with questions for last 24 hours" do
    mail_double = double("Mail", deliver_now: true)

    expect(NotificationsMailer).to receive(:daily_digest)
      .exactly(User.count).times
      .and_wrap_original do |m, *args|
        expect(args[0]).to be_a(User)
        expect(args[1]).to be_a(ActiveRecord::Relation)
        expect(args[1]).to include(new_question)
        expect(args[1]).not_to include(old_question)

        mail_double
      end

    described_class.new.send_digest
  end
end
