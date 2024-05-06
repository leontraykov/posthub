# frozen_string_literal: true

require 'rails_helper'

# PostsController manages the creation, display, and retrieval of posts.
# It includes actions for creating posts, retrieving individual posts, fetching top-rated posts,
# and finding IP addresses with multiple authors.
class PostsController < ActionController::API
  # POST /posts
  # Creates a new post under the specified user.
  # If the user with the given login does not exist, the user will be created.
  def create
    @user = User.find_or_create_by(login: params[:post][:login])
    @post = @user.posts.build(post_params)

    if @post.save
      render json: @post, status: :created
    else
      render json: { errors: @post.errors.messages }, status: :unprocessable_entity
    end
  end

  # GET /posts/:id
  # Retrieves and returns a specific post by its ID.
  def show
    @post = Post.find(params[:id]) # Find the post by its ID.
    render json: @post # Return the post data as JSON.
  end

  # GET /top_posts
  # Returns the top N posts by average rating.
  def top
    @posts = Post.joins(:ratings) # Join the posts and ratings tables.
                 .select('posts.id, posts.title, posts.body, AVG(ratings.value) as average_rating')
                 .group('posts.id') # Group by the post ID to aggregate ratings.
                 .order('average_rating DESC') # Sort by average rating in descending order.
                 .limit(params[:n].to_i) # Limit the result to N posts.

    # Return the post data as JSON, including the calculated average rating.
    render json: @posts.as_json(only: %i[id title body], methods: [:average_rating])
  end

  # GET /ips_with_multiple_authors
  # Returns a list of IP addresses that have posts published by multiple unique authors.
  def ips_with_multiple_authors
    # Select only IP addresses with more than one unique author.
    ips = Post.select(:ip).group(:ip).having('COUNT(DISTINCT user_id) > 1').pluck(:ip)

    # Fetch all posts matching these IPs in a single query.
    posts_with_ips = Post.includes(:user).where(ip: ips)

    # Group posts by IP and gather unique user logins for each IP.
    authors_by_ip = posts_with_ips.group_by(&:ip).transform_values do |posts|
      posts.map { |post| post.user.login }.uniq # Extract unique logins.
    end

    render json: authors_by_ip # Return the grouped IP addresses and logins as JSON.
  end

  private

  # Strong parameters to protect against unwanted input.
  # Allows only title, body, and IP address to be accepted for posts.
  def post_params
    params.require(:post).permit(:title, :body, :ip)
  end
end
