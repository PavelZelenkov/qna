class Award < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  has_one_attached :image

  validates :name, presence: true, if: :needs_award_validation?
  validates :image, presence: true, if: :needs_award_validation?

  private

  def needs_award_validation?
    name.present? || image.attached?
  end
end
