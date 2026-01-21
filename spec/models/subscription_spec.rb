require "rails_helper"

RSpec.describe Subscription, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:question) }
  end

  describe "validations" do
    subject { create(:subscription) }

    it { should validate_uniqueness_of(:user_id).scoped_to(:question_id) }
  end
end
