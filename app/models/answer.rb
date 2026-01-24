class Answer < ApplicationRecord
  include PgSearch::Model
  
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: :author_id
  has_many :links, dependent: :destroy, as: :linkable, inverse_of: :linkable
  has_many :votes, as: :votable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files

  after_commit :notify_about_new_answer, on: :create
  
  validates :body, presence: true

  multisearchable against: [:body]

  enum status: { best: 1, regular: 0 }

  scope :sorted, -> { order(status: :desc, created_at: :asc) }

  def select_as_best
    transaction do
      question.answers.update_all(status: :regular)
      update!(status: :best)
      question.award.update!(user: author) if question.award.present?
    end
  end

  private

  def notify_about_new_answer
    NewAnswerNotificationJob.perform_later(id)
  end
end
