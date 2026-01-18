class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :registerable,
         :recoverable, 
         :rememberable,
         :validatable,
         :omniauthable, omniauth_providers: %i[github twitter]

  has_many :answers_created, class_name: 'Answer', foreign_key: :author_id
  has_many :questions_created, class_name: 'Question', foreign_key: :author_id
  has_many :awards
  has_many :comments
  has_many :votes, as: :votable, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :email_confirmations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_questions, through: :subscriptions, source: :question

  def author_of?(model)
    model.author_id == id
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth['provider'], uid: auth['uid'].to_s)
  end

  def confirmed?
    self.confirmed
  end
end
