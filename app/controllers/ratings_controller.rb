# frozen_string_literal: true

# RatingsController is responsible for handling rating actions including creating ratings
# and updating the average rating of a post.
class RatingsController < ActionController::API
  # Creates a new rating after validating conditions.
  def create
    @post = load_post
    @rating = build_rating

    # Handle the rating creation within a transaction.
    ActiveRecord::Base.transaction do
      handle_rating_creation
    end
  end

  private

  # Handles the creation and conditional checks for a new rating.
  def handle_rating_creation
    if rating_exists?
      render_duplicate_rating_error
      raise ActiveRecord::Rollback # Rollback the transaction if a duplicate rating exists.
    end

    if @rating.save
      render_success
    else
      render_errors
      raise ActiveRecord::Rollback # Rollback the transaction if saving fails.
    end
  end

  # Loads the post from the database using the post_id from parameters.
  def load_post
    Post.find(params[:rating][:post_id])
  end

  # Builds a new rating instance using the submitted rating parameters.
  def build_rating
    @post.ratings.build(rating_params)
  end

  # Renders a JSON error response for duplicate rating attempts.
  def render_duplicate_rating_error
    render json: { error: I18n.t('rate_once_error') }, status: :unprocessable_entity
  end

  # Renders a successful JSON response including the newly created rating and its average rating.
  def render_success
    average_rating = update_average_rating
    render json: { rating: @rating, average_rating: }, status: :created
  end

  # Renders the validation errors if the rating save operation fails.
  def render_errors
    render json: { errors: @rating.errors.full_messages }, status: :unprocessable_entity
  end

  # Checks if a rating by the same user already exists for the post.
  def rating_exists?
    @post.ratings.exists?(user_id: params[:rating][:user_id])
  end

  # Calculates and returns the updated average rating for the post.
  def update_average_rating
    @post.ratings.average(:value).to_f.round(3)
  end

  # Ensures only the allowed parameters are passed to create a rating.
  def rating_params
    params.require(:rating).permit(:user_id, :value, :post_id)
  end
end
