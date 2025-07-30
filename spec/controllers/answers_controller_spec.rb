require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author_id: user.id) }
  let(:answer) { create(:answer, question_id: question.id, author_id: user.id) }
  
  describe "POST #create" do
    before { login(user) }

    context 'with valid attributes' do
      it 'creates and saves an answer to a question to the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question.id }, format: :js }.to change(Answer, :count).by(1)
      end
      it 'redirect to show view quetion' do
        post :create, params: { answer: attributes_for(:answer), question_id: question.id, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question.id }, format: :js }.to_not change(Answer, :count)
      end
      it 'redirect to show view quetion' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question.id }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do 
      before { login(user) }

      let!(:answer) { create(:answer, question_id: question.id, author_id: user.id) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
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
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(0)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: {id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: {id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: {id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #mark_as_best' do
    before { login(user) }

    let!(:answer) { create(:answer, question_id: question.id, author_id: user.id) }

    it 'calls mark_as_best at the desired answer' do
      expect_any_instance_of(Answer).to receive(:select_as_best)
      patch :mark_as_best, params: { id: answer.id }, format: :js
    end

    it 'marks the selected answer as best' do
      patch :mark_as_best, params: { id: answer.id }, format: :js
      expect(answer.reload.status).to eq 'best'
    end

    it 'renders mark_as_best view' do
      patch :mark_as_best, params: { id: answer.id }, format: :js
      expect(response).to render_template :mark_as_best
    end
  end

  describe "PATCH /answers/:id" do
    before { login(user) }

    let(:file) { fixture_file_upload(Rails.root.join("spec/rails_helper.rb")) }

    it 'adds a new file to the answer without deleting the old file' do
      answer.files.attach(
        io: File.open(Rails.root.join("spec/spec_helper.rb")),
        filename: "spec_helper.rb"
      )
      expect(answer.files.count).to eq 1

      patch :update, params: { id: answer, answer: { body: 'new body', files: [file] } }, format: :js
      answer.reload

      expect(answer.files.map(&:filename).map(&:to_s)).to include("rails_helper.rb", "spec_helper.rb")
    end

    it 'does not delete files if a new file is not added when editing a answer' do
      answer.files.attach(file)
      expect { patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js }.not_to change(ActiveStorage::Attachment, :count)
    end
  end
end
