require "rails_helper"

RSpec.describe SubscriptionsController, type: :controller do
  let(:user)     { create(:user) }
  let(:question) { create(:question, author: user) }

  before { sign_in user }

  describe "POST #create" do
    it "creates subscription if it does not exist" do
      expect {
        post :create, params: { question_id: question.id }
      }.to change(Subscription, :count).by(1)

      expect(response).to redirect_to(question_path(question))
    end

    it "does not create duplicate subscription" do
      Subscription.create(user_id: user.id, question_id: question.id)

      expect {
        post :create, params: { question_id: question.id }
      }.not_to change(Subscription, :count)

      expect(response).to redirect_to(question_path(question))
    end
  end

  describe "DELETE #destroy" do
    it "destroys subscription if it exists" do
      Subscription.create(user_id: user.id, question_id: question.id)

      expect {
        delete :destroy, params: { question_id: question.id }
      }.to change(Subscription, :count).by(-1)

      expect(response).to redirect_to(question_path(question))
    end

    it "does nothing if subscription is missing" do
      expect {
        delete :destroy, params: { question_id: question.id }
      }.not_to change(Subscription, :count)

      expect(response).to redirect_to(question_path(question))
    end
  end
end
