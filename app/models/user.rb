class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_many :questions
  has_many :answers
  has_many :votes
  has_many :authorization, dependent: :destroy

  def author_of?(object)
    id == object.user_id
  end

  def self.find_for_oath(auth)
    authorization = Authorization.where(provider: auth.provider, uid:auth.uid).first
    authorization.user = authorization
  end
end