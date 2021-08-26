# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

puts "Start seeding"
Like.destroy_all
Tweet.destroy_all
User.destroy_all

puts "Seeding users..."

# Create 1 admin user
admin = User.new(username: "admin", email: "admin@mail.com", name: "Admin", password: "supersecret", role: "admin")
puts "Admin not created. Errors: #{admin.errors.full_messages}" unless admin.save

# Create 4 member users
4.times do
  user_data = {
    username: Faker::Internet.unique.username,
    email: Faker::Internet.unique.safe_email,
    name: Faker::Name.name,
    password: Faker::Internet.password(min_length: 6)
  }
  new_user = User.new(user_data)
  puts "User not created. Errors: #{new_user.errors.full_messages}" unless new_user.save

  # Each member should create some tweets
  puts "Seeding tweets for user..."
  rand(2..4).times do
    tweet_data = {
      body: Faker::Lorem.paragraph(sentence_count: 1, random_sentences_to_add: 2),
      user: new_user
    }
    new_tweet = Tweet.new(tweet_data)
    puts "Tweet not created. Errors: #{new_tweet.errors.full_messages}" unless new_tweet.save
  end
end

# Each member should reply to some other tweets
puts "Seeding reply tweets..."
User.all.each do |user|
  rand(2..4).times do
    parent_tweet = Tweet.all
    reply_data = {
      body: Faker::Lorem.paragraph(sentence_count: 1, random_sentences_to_add: 2),
      user: user,
      replied_to: parent_tweet.sample
    }
    new_reply = Tweet.new(reply_data)
    puts "Reply not created. Errors: #{new_reply.errors.full_messages}" unless new_reply.save
  end
end

# Each member should like some tweets
puts "Seeding likes..."
User.all.each do |user|
  tweets = Tweet.all
  rand(2..4).times do
    like_data = {
      user: user,
      tweet: tweets.sample
    }
    new_like = Like.new(like_data)
    puts "Like not created. Errors: #{new_like.errors.full_messages}" unless new_like.save
  end
end

puts "Seeding finish..."
