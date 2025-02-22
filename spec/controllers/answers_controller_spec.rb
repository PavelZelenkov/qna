require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author_id: user.id) }
  let(:answer) { create(:answer, question_id: question.id, author_id: user.id) }
  
  describe "POST #create" do
    before { login(user) }

    context 'with valid attributes' do
      it 'creates and saves an answer to a question to the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question.id } }.to change(Answer, :count).by(1)
      end
      it 'redirect to show view quetion' do
        post :create, params: { answer: attributes_for(:answer), question_id: question.id }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question.id } }.to_not change(Answer, :count)
      end
      it 'redirect to show view quetion' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question.id }
        expect(response).to redirect_to assigns(:question)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do 
      before { login(user) }

      let!(:answer) { create(:answer, question_id: question.id, author_id: user.id) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to answer.question
      end
    end

    context 'Unauthenticated user' do   
      let!(:answer) { create(:answer, question_id: question.id, author_id: user.id) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(0)
      end

      it 'redirects to sign_in' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to user_session_path
      end
    end

    context 'Authenticated user' do 
      before { login(user) }

      let(:user_test) {create(:user)}
      let!(:answer) { create(:answer, question_id: question.id, author_id: user_test.id) }

      it "tries to delete someone else's answer" do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(0)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to answer.question
      end
    end
  end
end
