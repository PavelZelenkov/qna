require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :author }
  it { should have_many(:links).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }

  it { should validate_presence_of :body }

  let(:user) { create(:user) }
  let(:question) { create(:question, author: user ) }
  let!(:answer1) { create(:answer, question: question, author: user, status: :regular) }
  let!(:answer2) { create(:answer, question: question, author: user, status: :best) }

  describe '#select_as_best' do
   it 'makes the selected answer the best and the rest normal' do
    answer1.select_as_best

    expect(answer1.reload.status).to eq 'best'
    expect(answer2.reload.status).to eq 'regular'
   end

   it 'does not change the status of the best answer in a group of other questions' do
    other_question = create(:question, author: user)
    other_answer = create(:answer, question: other_question, author: user, status: :best)

    answer1.select_as_best

    expect(other_answer.reload.status).to eq 'best'
   end
  end
end
