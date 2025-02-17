require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :answers_created }
  it { should have_many :questions_created }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
end
