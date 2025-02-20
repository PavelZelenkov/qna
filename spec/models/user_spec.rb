require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :answers_created }
  it { should have_many :questions_created }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user) { create_list(:user, 2) }

  it 'author verification - true' do
    answer = Answer.new(body: "AnswerBody", author_id: user.first.id)

    expect(user.first.author_of?(answer)).to_not be_falsey
  end

  it 'author verification - false' do
    answer = Answer.new(body: "AnswerBody", author_id: user.last.id)

    expect(user.first.author_of?(answer)).to be_falsey
  end
end
