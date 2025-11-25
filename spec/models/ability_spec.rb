require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:other_question) { create(:question, author: other) }
    let(:answer) { create(:answer, question: question, author: user) }
    let(:other_answer) { create(:answer, question: question, author: other) }
    let(:link) { create(:link, linkable: question, url: 'http://google.com') }
    let(:other_link) { create(:link, linkable: other_question, url: 'http://google.com') }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, author: user), user: user }
    it { should_not be_able_to :update, create(:question, author: other), user: user }

    it { should be_able_to :update, create(:answer, author: user, question: question), user: user }
    it { should_not be_able_to :update, create(:answer, author: other, question: question), user: user }

    it { should be_able_to(:like, other_question) }
    it { should_not be_able_to(:like, question) }
  
    it { should be_able_to(:like, other_answer) }
    it { should_not be_able_to(:like, answer) }

    it { should be_able_to(:mark_as_best, other_answer) }
    it { should_not be_able_to(:mark_as_best, create(:answer, question: other_question, author: other)) }

    it { should be_able_to(:destroy, link) }
    it { should_not be_able_to(:destroy, other_link) }
  end
end
