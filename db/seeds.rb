# frozen_string_literal: true

# Script for populating the database with initial data for users, posts, and ratings.

# Uncomment this method to be able to run validations before saving objects
Rails.logger.info 'Validations OFF. If required uncomment validate_records method in seeds.rb
 and the lines where this method is applied'
# def validate_records(records, model)
#   Rails.logger.info "Validating #{model.name.downcase.pluralize} =>"
#   valid_records = records.filter { |record| model.new(record).valid? }
#   Rails.logger.info "#{model.name.pluralize} are valid, ready to save"
#   valid_records
# end

# Creating users
Rails.logger.info 'Creating users =>'
users = Array.new(100) { |i| { login: "user_#{i}", created_at: Time.current, updated_at: Time.current } }
# users = validate_records(users, User)
User.insert_all(users)
Rails.logger.info 'Users have been created!'

# Creating IP addresses
Rails.logger.info 'Creating IP adresses =>'
ips = Array.new(50) { |_i| "192.168.#{rand(1..254)}.#{rand(1..254)}" }
Rails.logger.info 'IP adresses have been created!'

# Creating posts
Rails.logger.info 'Creating posts =>'
posts = []
total_posts = 200_000
total_posts.times do |i|
  post = {
    title: Faker::Lorem.sentence(word_count: 3),
    body: Faker::Lorem.sentence(word_count: 5),
    user_id: rand(1..100),
    ip: ips[i % ips.length],
    created_at: Time.current,
    updated_at: Time.current
  }
  posts << post
  next unless posts.size >= 10_000

  # posts = validate_records(posts, Post)
  Post.insert_all(posts)
  Rails.logger.info "#{i + 1} / #{total_posts} posts created..."
  posts.clear
end
Post.insert_all(posts) unless posts.empty?
Rails.logger.info 'All posts have been created!'

# Creating ratings
Rails.logger.info 'Creating ratings =>'
ratings = []
count_created_ratings = 0
Post.limit(150_000).find_each do |post|
  rating = {
    post_id: post.id,
    user_id: rand(1..100),
    value: rand(1..5),
    created_at: Time.current,
    updated_at: Time.current
  }
  ratings << rating
  if ratings.size >= 10_000
    # ratings = validate_records(ratings, Rating)
    Rating.insert_all(ratings)
    count_created_ratings += ratings.size
    Rails.logger.info "Ratings created: #{count_created_ratings}"
    ratings.clear
  end
end
if ratings.any?
  # ratings = validate_records(ratings, Rating)
  Rating.insert_all(ratings)
  count_created_ratings += ratings.size
  Rails.logger.info "Final ratings created: #{count_created_ratings}"
end
Rails.logger.info 'All ratings have been created!'
