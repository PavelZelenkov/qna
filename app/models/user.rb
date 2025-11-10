class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :registerable,
         :recoverable, 
         :rememberable,
         :validatable

  has_many :answers_created, class_name: 'Answer', foreign_key: :author_id
  has_many :questions_created, class_name: 'Question', foreign_key: :author_id
  has_many :awards
  has_many :comments
  has_many :votes, as: :votable, dependent: :destroy

  def author_of?(model)
    model.author_id == id
  end
end
