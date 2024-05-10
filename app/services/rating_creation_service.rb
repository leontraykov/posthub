# frozen_string_literal: true

class RatingCreationService
  def initialize(post, rating_params)
    @post = post
    @rating_params = rating_params
  end

  def call
    ActiveRecord::Base.transaction do
      create_rating
    end
  end

  private

  def create_rating
    return { error: 'Rating already exists', status: :unprocessable_entity } if rating_exists?

    rating = @post.ratings.build(@rating_params)
    if rating.save
      { rating: rating, average_rating: update_average_rating, status: :created }
    else
      { errors: rating.errors.full_messages, status: :unprocessable_entity }
    end
  end

  def rating_exists?
    @post.ratings.exists?(user_id: @rating_params[:user_id])
  end

  def update_average_rating
    @post.ratings.average(:value).to_f.round(2)
  end
end
