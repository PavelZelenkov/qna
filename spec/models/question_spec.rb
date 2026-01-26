require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should belong_to :author }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end

  describe 'pg_search' do
    it 'indexes title and body for multisearch' do
      PgSearch::Multisearch.rebuild(Question)

      question = create(:question, title: 'Test question', body: 'Test body')
      PgSearch::Multisearch.rebuild(Question)

      results = PgSearch.multisearch('Test question')
      expect(results.map(&:searchable)).to include(question)
    end

    it 'finds by pg_search_scope' do
      needed  = create(:question, title: 'Ruby question', body: 'Why?')
      _other  = create(:question, title: 'Other question', body: 'Something else')

      results = Question.search_by_title_and_body('Ruby')
      expect(results).to include(needed)
      expect(results).not_to include(_other)
    end
  end
end
