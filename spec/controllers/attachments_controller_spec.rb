require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author_id: user.id) }

  let!(:attachment) do
    question.files.attach(
      io: File.open(Rails.root.join("spec/spec_helper.rb")),
      filename: "spec_helper.rb"
    )
    question.files.last
  end
  
  describe 'DELETE #destroy' do
    before { login(user) }

    it 'deletes file' do
      expect {  
        delete :destroy, params: { id: attachment.id }, format: :js
      }.to change(ActiveStorage::Attachment, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end
