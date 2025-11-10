require 'rails_helper'

RSpec.describe QuestionsChannel, type: :channel do
  let(:user) { create(:user) }
  let(:question) { create(:question, author_id: user.id) }

  before do
    stub_connection current_user: user
  end

  it 'subscribes to questions channel' do
    subscribe

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("questions")
  end

  it 'subscribes to answers to a specific question' do
    subscribe(question_id: question.id)

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("answers_for_question_#{question.id}")
  end

  it 'subscribes to comments on a specific question' do
    subscribe(question_id: question.id)

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("comments_for_question_#{question.id}")
  end
end
