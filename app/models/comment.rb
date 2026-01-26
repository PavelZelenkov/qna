class Comment < ApplicationRecord
  include PgSearch::Model
  
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true

  multisearchable against: [:body]
end
