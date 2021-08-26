class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # validations
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :name, presence: true

  # Enums
  enum role: { member: 0, admin: 1 }

  # Associations
  has_many :tweets, dependent: :destroy
  has_many :liked_tweets, class_name: 'Tweet', foreign_key: 'tweet_id', through: :likes
  # has_one_attached :avatar

  has_secure_token
end
