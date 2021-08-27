class Tweet < ApplicationRecord
  belongs_to :user
  belongs_to :replied_to, class_name: 'Tweet', optional: true, counter_cache: 'replies_count'

  has_many :likes, dependent: :destroy
  has_many :liked_users, class_name: 'User', foreign_key: 'user_id', through: :likes
  has_many :replies, class_name: 'Tweet', foreign_key: 'replied_to_id', dependent: :destroy,
                     inverse_of: 'replied_to'
  # validation
  validates :body, presence: true, length: { maximum: 140 }
  # validates :replied_to, :replied_to_id,
  #           inclusion: { in: proc { Tweet.all },
  #                        message: 'is not a valid tweet' },
  #           if: proc { replied_to || replied_to_id }
end
