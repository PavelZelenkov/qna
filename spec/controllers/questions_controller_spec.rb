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
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirect to updates question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }
      it 'does not change question' do
        question.reload

        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
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
end
