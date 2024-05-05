# frozen_string_literal: true

# Model for posts. Posts are created by users and can be rated.
# Posts must have a title, body, and IP address from which they were created.
class Post < ApplicationRecord
  # Associations
  belongs_to :user # The user who created the post.
  has_many :ratings, dependent: :destroy # Ratings given to the post.

  # Validations
  validates :title, presence: true  # Ensures the post has a title.
  validates :body, presence: true   # Ensures the post has a body.
  validates :ip, presence: true     # Ensures the post has an associated IP address.
end
