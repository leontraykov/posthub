# frozen_string_literal: true

# PostsController manages the creation, display, and retrieval of posts.
# It includes actions for creating posts, retrieving individual posts, fetching top-rated posts,
# and finding IP addresses with multiple authors.
class PostsController < ActionController::API
  # POST /posts
  # Creates a new post under the specified user.
  # If the user with the given login does not exist, the user will be created.

  def create
    user = User.find_or_create_by(login: params[:post][:login])
    result = PostCreationService.new(user, post_params).call
    render json: result[:json], status: result[:status]
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
    render json: IpAnalysisService.new.call
  end

  private

  def render_user_error
    render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
  end

  def render_post_error
    render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
  end

  # Strong parameters to protect against unwanted input.
  # Allows only title, body, and IP address to be accepted for posts.
  def post_params
    params.require(:post).permit(:title, :body, :ip)
  end
end
