class User < ApplicationRecord
  # Enums
  enum role: { member: 0, admin: 1 }

  # Associations
  has_many :tweets, dependent: :destroy
  has_many :likes, through: :tweets

  has_secure_token
end
