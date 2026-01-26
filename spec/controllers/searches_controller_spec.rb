require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #index' do
    let!(:question) { create(:question, title: 'Best Rails question') }
    let!(:answer) { create(:answer, body: 'Special answer text') }
    let!(:comment) { create(:comment, body: 'Helpful comment') }
    let!(:user) { create(:user, email: 'testuser@gmail.com') }

    before do
      PgSearch::Multisearch.rebuild(Question)
      PgSearch::Multisearch.rebuild(Answer)
      PgSearch::Multisearch.rebuild(Comment)
    end

    it 'returns empty results when query is blank' do
      get :index, params: { query: '', scope: 'all' }

      expect(assigns(:results)).to eq([])
      expect(response).to render_template :index
    end

    it 'searches everywhere when scope is all' do
      get :index, params: { query: 'Best', scope: 'all' }

      expect(assigns(:results).map(&:searchable)).to include(question)
    end

    it 'searches only in questions when scope = questions' do
      get :index, params: { query: 'Best', scope: 'questions' }

      expect(assigns(:results)).to match_array([question])
    end

    it 'searches only in answers when scope = answers' do
      get :index, params: { query: 'Special', scope: 'answers' }

      expect(assigns(:results).map(&:searchable)).to include(answer)
      expect(assigns(:results).map(&:searchable)).not_to include(question, comment)
    end

    it 'searches only in comments when scope = comments' do
      get :index, params: { query: 'Helpful', scope: 'comments' }

      expect(assigns(:results).map(&:searchable)).to include(comment)
      expect(assigns(:results).map(&:searchable)).not_to include(question, answer)
    end

    it 'searches users by email prefix when scope = users' do
      get :index, params: { query: 'testuser', scope: 'users' }

      expect(assigns(:results)).to include(user)
      expect(assigns(:results)).not_to include(question, answer, comment)
    end
  end
end
