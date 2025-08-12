require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author_id: user.id) }

  let!(:link) { create(:link, linkable: question, url: "https://gist.github.com") }

  describe 'DELETE #destroy' do
    before { login(user) }

    it 'deletes file' do
      expect { delete :destroy, params: { id: link.id }, format: :js }.to change(Link, :count).by(-1)
    end
  end
end
