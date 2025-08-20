require 'rails_helper'

RSpec.describe Award, type: :model do
  it { should belong_to :question }
  it { should belong_to(:user).optional }
  it { should have_one_attached(:image) }

  let(:user) { create(:user) }
  let(:question) { create(:question, author: user ) }

  describe 'validations' do
    context 'when neither name nor image given' do
      subject { build(:award, name: '', image: nil, question: question) }
      it { is_expected.to be_valid }
    end

    context 'only name is given' do
      subject {build(:award, name: 'NameAward', image: nil, question: question) }
      it 'does not work without image' do
        expect(subject).not_to be_valid
        expect(subject.errors[:image]).to include("can't be blank")
      end
    end

    context 'attach only the image' do
      subject { build(:award, name: '', question: question) }
      before { subject.image.attach(io: File.open(Rails.root.join('spec/fixtures/files/award1.jpg')), 
      filename: 'award1.jpg', content_type: 'image/jpg') }

      it "doesn't work without a name" do
        expect(subject).not_to be_valid
        expect(subject.errors[:name]).to include("can't be blank")
      end
    end

    context 'both name and image are given' do
      subject { build(:award, name: 'NameAward', question: question) }
      before { subject.image.attach(io: File.open(Rails.root.join('spec/fixtures/files/award1.jpg')), 
      filename: 'award1.jpg', content_type: 'image/jpg') }

      it { is_expected.to be_valid }
    end
  end
end
