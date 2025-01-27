require 'rails_helper'

RSpec.describe AnswerController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question_id: question.id) }
  
  describe "POST answers#create" do
    context 'with valid attributes' do
      it 'creates and saves an answer to a question to the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question.id } }.to change(Answer, :count).by(1)
        # puts question.inspect
        # puts answer.inspect
      end
      # it 'redirect to show view quetion'
    end

    # context 'with invalid attributes'
  end
end
