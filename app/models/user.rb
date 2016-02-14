class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :github]

  has_many :questions
  has_many :answers
  has_many :votes
  has_many :authorizations, dependent: :destroy
  has_many :subscribers_questions, dependent: :destroy
  has_many :subscribed_questions, through: :subscribers_questions, source: :question

  def subscribe_to(question)
    subscribed_questions << question
  end

  def unsubscribe_from(question)
    subscribed_questions.delete(question)
  end

  def author_of?(object)
    id == object.user_id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first
    unless user
      password = Devise.friendly_token(20)
      user = User.create!(email: email, password: password, password_confirmation: password)
    end

    user.authorizations.create!(provider: auth.provider, uid: auth.uid)
    user
  end
end