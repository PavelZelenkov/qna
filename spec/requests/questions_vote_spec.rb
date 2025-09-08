require 'rails_helper'

RSpec.describe 'Questions Votes', type: :request do
  let(:question) { create(:question, author_id: user.id) }
  let(:user) { create(:user) }

  describe 'POST /questions/:id/vote' do
    context 'registered user not author' do
      before { sign_in user }

      it 'likes the question' do
        expect { post vote_question_path(question), params: { value: 1 } }.to change { question.votes.where(value: 1, user: user).count }.by(1)
        expect(response).to have_http_status(:success)

        expect(JSON.parse(response.body)).to include("rating" => 1)
      end

      it 'pressing again removes the vote' do
        post vote_question_path(question), params: { value: 1 }
        expect { post vote_question_path(question), params: { value: 1 } }.to change { question.votes.where(value: 1, user: user).count }.by(-1)
        
        expect(JSON.parse(response.body)).to include("rating" => 0)
      end

      it 'changes the voice from like to dislike' do
        expect {
          post vote_question_path(question), params: { value: 1 }
          post vote_question_path(question), params: { value: -1 }
          question.reload
        }.to change { question.votes.where(value: -1, user: user).count }.by(1)

        expect(JSON.parse(response.body)).to include("rating" => -1)
      end
    end

    context 'user without authorization' do
      it 'returns 401 error or redirect' do
        post vote_question_path(question), params: { value: 1 }
        expect(response).to have_http_status(:unauthorized).or have_http_status(:found)
      end
    end
  end
end
