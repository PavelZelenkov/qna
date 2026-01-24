require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:commentable) }

  describe 'multisearchable' do
    it 'indexes body to multisearch' do
      comment = create(:comment, body: 'Nice comment')

      PgSearch::Multisearch.rebuild(Comment)

      results = PgSearch.multisearch('Nice')
      expect(results.map(&:searchable)).to include(comment)
    end
  end
end
