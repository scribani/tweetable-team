class Tweet < ApplicationRecord
  belongs_to :user
  belongs_to :replied_to, class_name: 'Tweet', optional: true, counter_cache: 'replies_count'
  has_many :liked_users, class_name: 'User', foreign_key: 'user_id', through: :likes
  has_many :replies, class_name: 'Tweet', foreign_key: 'replied_to_id', dependent: :nullify,
                     inverse_of: 'replied_to'
end
