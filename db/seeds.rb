# frozen_string_literal: true

# Script for populating the database with initial data for users, posts, and ratings.

# Creating users
Rails.logger.debug 'Creating users =>'
users = 100.times.map { |i| { login: "user_#{i}", created_at: Time.current, updated_at: Time.current } }
User.insert_all(users) # Bulk insert to optimize performance.
Rails.logger.debug 'Users have been created!'

# Creating IP addresses
Rails.logger.debug 'Creating IP adresses =>'
ips = 50.times.map { |_i| "192.168.#{rand(1..254)}.#{rand(1..254)}" } # Generate random IP addresses.
Rails.logger.debug 'IP adresses have been created!'

# Creating posts
Rails.logger.debug 'Creating posts =>'
posts = []
total_posts = 200_000 # Total number of posts to create.
total_posts.times do |i|
  user_id = rand(1..100) # Randomly assign a user id from the created users.
  ip = ips[i % ips.length] # Cycle through the IP list for each post.
  posts << {
    title: Faker::Lorem.sentence(word_count: 3),
    body: Faker::Lorem.sentence(word_count: 5),
    user_id:,
    ip:,
    created_at: Time.current,
    updated_at: Time.current
  }
  # Insert 10,000 posts at a time to optimize database insertion performance.
  next unless posts.size >= 10_000

  Post.insert_all(posts)
  posts.clear
  Rails.logger.debug "#{i + 1} / #{total_posts} posts created..."
end
Post.insert_all(posts) unless posts.empty? # Insert any remaining posts.
Rails.logger.debug 'All posts have been created!'

# Creating ratings
Rails.logger.debug 'Creating ratings =>'
ratings = []
count_created_ratings = 0
Post.limit(150_000).find_each do |post|
  ratings << {
    post_id: post.id,
    user_id: rand(1..100), # Assign a random user to rate the post.
    value: rand(1..5), # Random rating value between 1 and 5.
    created_at: Time.current,
    updated_at: Time.current
  }
  # Insert 10,000 ratings at a time for performance.
  if ratings.size >= 10_000
    Rating.insert_all(ratings)
    count_created_ratings += ratings.size
    Rails.logger.debug "Ratings created: #{count_created_ratings}"
    ratings.clear
  end
end
if ratings.any?
  Rating.insert_all(ratings)
  count_created_ratings += ratings.size
  Rails.logger.debug "Ratings created: #{count_created_ratings}"
end
Rails.logger.debug 'All ratings have been created!'
