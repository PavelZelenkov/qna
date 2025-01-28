require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question_id: question.id) }
  
  describe "POST answers#create" do
    context 'with valid attributes' do
      it 'creates and saves an answer to a question to the database' do
        # count = Answer.count
        puts Answer.count
        # post :create, params: { answer: {body: '123'}, question_id: question.id }
        # expect(Answer.count).to eq count + 1
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question.id } }.to change(Answer, :count).by(1)
        # puts question.inspect
        # puts answer.inspect
        puts Answer.count
      end
      it 'redirect to show view quetion' do
        post :create, params: { answer: attributes_for(:answer), question_id: question.id }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      
    end
  end
end
