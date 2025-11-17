require 'rails_helper'

RSpec.describe EmailConfirmation, type: :model do
  it { should belong_to :user }

  let(:user) { User.create!(email: 'test@mail.ru', password: '12345678') }

  it 'is valid with valid attributes' do
    confirmation = EmailConfirmation.new(user: user, token: 'uniq123')
    expect(confirmation).to be_valid
  end

  it 'is invalid without a user' do
    confirmation = EmailConfirmation.new(token: 'uniq321')
    expect(confirmation).not_to be_valid
    expect(confirmation.errors[:user]).to be_present
  end

  it 'is invalid without a token' do
    confirmation = EmailConfirmation.new(user: user)
    expect(confirmation).not_to be_valid
    expect(confirmation.errors[:token]).to be_present
  end

  it 'is invalid with a non-unique token' do
    EmailConfirmation.create!(user: user, token: 'doubletoken')
    other_user = User.create!(email: 'other@mail.ru', password: '87654321')
    confirmation2 = EmailConfirmation.new(user: other_user, token: 'doubletoken')
    expect(confirmation2).not_to be_valid
    expect(confirmation2.errors[:token]).to be_present
  end
end
