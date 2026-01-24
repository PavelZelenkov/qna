require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :answers_created }
  it { should have_many :questions_created }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'author verification' do
    let(:user) { create_list(:user, 2) }

    it 'true' do
      answer = Answer.new(body: "AnswerBody", author_id: user.first.id)

      expect(user.first).to be_author_of(answer)
    end

    it 'false' do
      answer = Answer.new(body: "AnswerBody", author_id: user.last.id)

      expect(user.first).to_not be_author_of(answer)
    end
  end

  describe 'find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '.search_by_email' do
    it 'finds by full email' do
      needed = create(:user, email: 'testuser@gmail.com')
      other = create(:user, email: 'someone@gmail.com')

      results = User.search_by_email('testuser@gmail.com')

      expect(results).to include(needed)
      expect(results).not_to include(other)
    end

    it 'finds by email prefix' do
      needed = create(:user, email: 'testuser@gmail.com')
      other = create(:user, email: 'another@gmail.com')

      results = User.search_by_email('testuser')

      expect(results).to include(needed)
      expect(results).not_to include(other)
    end
  end
end
