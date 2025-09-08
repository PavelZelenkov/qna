require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:votable) }

  let(:user) { create(:user) }
  let(:question) { create(:question, author: user ) }
  let(:answer) { create(:answer, question: question, author: user) }

  describe 'Validations' do
    context 'value validation' do
      it { should validate_inclusion_of(:value).in_array([1, -1]) }

      it 'is valid with value 1' do
        vote = build(:vote, user: user, votable: question, value: 1)
        expect(vote).to be_valid
      end

      it 'is valid with value -1' do
        vote = build(:vote, user: user, votable: question, value: -1)
        expect(vote).to be_valid
      end

      it 'is invalid with value 0' do
        vote = build(:vote, user: user, votable: question, value: 0)
        expect(vote).not_to be_valid
        expect(vote.errors[:value]).to include('is not included in the list')
      end

      it 'is invalid with value 2' do
        vote = build(:vote, user: user, votable: question, value: 2)
        expect(vote).not_to be_valid
      end
    end

    context 'uniqueness validation' do
      it 'allows one user to vote on one question/answer at a time' do
        create(:vote, user: user, votable: question, value: 1)
        duplicate_vote = build(:vote, user: user, votable: question, value: -1)

        expect(duplicate_vote).not_to be_valid
        expect(duplicate_vote.errors[:user_id]).to include('has already been taken')
      end

      it 'allows the same user to vote for different answers/questions' do
        create(:vote, user: user, votable: question, value: 1)
        vote_for_answer = build(:vote, user: user, votable: answer, value: 1)

        expect(vote_for_answer).to be_valid
      end

      it 'allows different users to vote on the same question/answer' do
        another_user = create(:user)
        create(:vote, user: user, votable: question, value: 1)
        vote_by_another = build(:vote, user: another_user, votable: question, value: -1)

        expect(vote_by_another).to be_valid
      end
    end
  end
end
