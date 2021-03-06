class User < ApplicationRecord
  attr_accessor :skip_password_validation

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github]

  # validations
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :name, presence: true

  # Enums
  enum role: { member: 0, admin: 1 }

  # Associations
  has_many :tweets, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_tweets, class_name: 'Tweet', foreign_key: 'tweet_id', through: :likes
  has_one_attached :avatar
  has_secure_token

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.complete_attributes(auth.info)
    end
  end

  def complete_attributes(info)
    self.username = info.nickname
    self.name = info.name
    self.email = info.email
    self.password = Devise.friendly_token[6, 20]
  end

  def invalidate_token
    update(token: nil)
  end

  private

  # This allows us to skip devise password validation if we set skip_password_validation as true
  def password_required?
    return false if skip_password_validation

    super
  end
end
