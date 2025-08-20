class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: :author_id
  has_many :links, dependent: :destroy, as: :linkable, inverse_of: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files
  
  validates :body, presence: true

  enum status: { best: 1, regular: 0 }

  scope :sorted, -> { order(status: :desc, created_at: :asc) }

  def select_as_best
    transaction do
      question.answers.update_all(status: :regular)
      update!(status: :best)
      question.award.update!(user: author) if question.award.present?
    end
  end
end
