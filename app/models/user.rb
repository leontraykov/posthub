# frozen_string_literal: true

# Model for users. Users can create posts and rate them.
# Each user is identified uniquely by their login.
class User < ApplicationRecord
  # Associations
  has_many :posts, dependent: :destroy # Posts created by the user.
  has_many :ratings, dependent: :destroy # Ratings given by the user.

  # Validations
  validates :login, presence: true, uniqueness: true # Ensures login is present and unique.
end
