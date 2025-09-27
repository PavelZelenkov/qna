require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author_id: user.id) }
  let(:answer) { create(:answer, question_id: question.id, author_id: user.id) }

  before { sign_in user }

  shared_examples "comments index json" do |commentable_factory|
    let(:commentable) { send(commentable_factory) }
    let!(:comments) do
      create_list(:comment, 2, commentable: commentable, user: user, created_at: 1.hour.ago)
      create(:comment, commentable: commentable, user: user, created_at: 10.minutes.ago)
    end

    it "returns ordered list with user projection" do
      get :index, params: index_params(commentable), format: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      times = json.map { |h| Time.parse(h["created_at"]) }
      expect(times).to eq(times.sort)

      json.each do |h|
        expect(h.keys).to include("id", "body", "created_at", "user")
        expect(h["user"].keys).to include("id")
      end
    end
  end

  shared_examples "comments create json" do |commentable_factory|
    let(:commentable) { send(commentable_factory) }

    context "with valid params" do
      it "creates comment and returns json" do
        expect do
          post :create, params: create_params(commentable, body: "test comment"), format: :json
        end.to change(Comment, :count).by(1)

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json.slice("id", "body").values_at("body")).to eq(["test comment"])

        expect(Comment.last.commentable).to eq(commentable)
        expect(Comment.last.user).to eq(user)
      end
    end

    context "with invalid params" do
      it "does not create and returns 422 with errors" do
        expect do
          post :create, params: create_params(commentable, body: ""), format: :json
        end.not_to change(Comment, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["errors"]).to be_present
      end
    end
  end

  describe "GET #index (question)" do
    it_behaves_like "comments index json", :question
  end

  describe "GET #index (answer)" do
    it_behaves_like "comments index json", :answer
  end

  describe "GET #create (question)" do
    it_behaves_like "comments create json", :question
  end

  describe "GET #create (answer)" do
    it_behaves_like "comments create json", :answer
  end

  private

  def index_params(commentable)
    if commentable.is_a?(Question)
      { question_id: commentable.id }
    else
      { answer_id: commentable.id }
    end
  end

  def create_params(commentable, body:)
    base = { comment: { body: body } }
    if commentable.is_a?(Question)
      base.merge(question_id: commentable.id)
    else
      base.merge(answer_id: commentable.id)
    end
  end
end
