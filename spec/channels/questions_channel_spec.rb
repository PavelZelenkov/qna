require 'rails_helper'

RSpec.describe QuestionsChannel, type: :channel do
  let(:user) { create(:user) }

  before do
    stub_connection current_user: user
  end

  it 'subscribes to questions' do
    subscribe

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from('questions')
  end
end
