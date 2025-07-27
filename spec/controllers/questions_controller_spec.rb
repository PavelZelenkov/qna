require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question, author_id: user.id) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, author_id: user.id) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the request question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }
    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    before { get :edit, params: { id: question } }

    it 'assigns the request question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end
      it 'redirect to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end
    
    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-render new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the request question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirect to updates question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }
      it 'does not change question' do
        question.reload

        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 're-render edit view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do 
      before { login(user) }
      
      let!(:question) { create(:question, author_id: user.id) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Unauthenticated user' do 
      let!(:question) { create(:question, author_id: user.id) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(0)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to user_session_path
      end
    end

    context 'Authenticated user' do 
      before { login(user) }
      
      let(:user_test) {create(:user)}
      let!(:question) { create(:question, author_id: user_test.id) }

      it "tries to delete someone else's answer" do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(0)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to question
      end
    end
  end

  describe "PATCH /questions/:id" do
    before { login(user) }

    let(:file) { fixture_file_upload(Rails.root.join("spec/rails_helper.rb")) }

    it 'adds a new file to the question without deleting the old file' do
      question.files.attach(
        io: File.open(Rails.root.join("spec/spec_helper.rb")),
        filename: "spec_helper.rb"
      )
      expect(question.files.count).to eq 1

      patch :update, params: { id: question, question: { title: 'new title', body: 'new body', files: [file] } }, format: :js
      question.reload

      expect(question.files.map(&:filename).map(&:to_s)).to include("rails_helper.rb", "spec_helper.rb")
    end

    it 'does not delete files if a new file is not added when editing a question' do
      question.files.attach(file)
      expect { patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js }.not_to change(ActiveStorage::Attachment, :count)
    end
  end

  describe "DELETE /questions/:id/delete_file" do
    before { login(user) }

    let!(:file) do
      question.files.attach(
        io: File.open(Rails.root.join("spec/spec_helper.rb")),
        filename: "spec_helper.rb"
      )
      question.files.last
    end

    it 'deletes file from question' do
      expect {  
        delete :delete_file, params: { id: question.id, file_id: file.id }, format: :js
      }.to change(ActiveStorage::Attachment, :count).by(-1)

      expect(response).to have_http_status(:ok)
      expect { file.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect(Question.exists?(question.id)).to be true
    end
  end
end
