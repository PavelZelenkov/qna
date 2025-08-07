require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe "Validation URL" do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user ) }
    let(:link) { described_class.new(name: "Link name", url: url, linkable: question) }

    context "invalid format url" do
      let(:url) { "not_a_url" }

      it "is invalid" do
        expect(link).to be_invalid
        expect(link.errors[:url]).to include("it is not valid URL")
      end
    end

    context "with missing TDL" do
      let(:url) { "http://gist" }

      it "is invalid" do
        expect(link).to be_invalid
        expect(link.errors[:url]).to include("it is not valid URL")
      end
    end

    context "with valid url" do
      let(:url) { "https://gist.github.com" }

      it "is valid" do
        expect(link).to be_valid
      end
    end
  end
end
