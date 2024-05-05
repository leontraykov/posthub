# frozen_string_literal: true

# RatingsController is responsible for handling rating actions including creating ratings
# and updating the average rating of a post.
class RatingsController < ApplicationController
  # POST /ratings
  # Creates a new rating for a post by a user. Ensures that each user can rate a post only once.
  def create
    @rating = Rating.new(rating_params)

    # Check if the rating already exists to prevent duplicate ratings.
    return if rating_exists?

    # Save the rating and calculate the average rating if successful, else return errors.
    if @rating.save
      average_rating = update_average_rating(@rating.post_id)
      render json: { rating: @rating, average_rating: }, status: :created
    else
      render json: { errors: @rating.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Strong parameters: Ensures only the allowed parameters are passed to create a rating.
  def rating_params
    params.require(:rating).permit(:post_id, :user_id, :value)
  end

  # Check for an existing rating by the same user on the same post.
  # Renders an error if a duplicate rating is found.
  def rating_exists?
    existing_rating = Rating.find_by(post_id: params[:post_id], user_id: params[:user_id])
    if existing_rating
      render json: { error: I18n.t('rate_once_error') }, status: :unprocessable_entity
      return true
    end
    false
  end

  # Updates and returns the average rating for a post.
  # This method calculates the average after a new rating is successfully saved.
  def update_average_rating(post_id)
    post = Post.find(post_id)
    post.ratings.average(:value).to_f.round(3) # Round to three decimal places for precision.
  end
end
