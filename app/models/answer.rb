class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: :author_id

  validates :body, presence: true

  enum status: { best: 1, regular: 0 }

  scope :sorted, -> { order(status: :desc, created_at: :asc) }

  def select_as_best
    question.answers.update_all(status: :regular)
    update(status: :best)
  end
end
