# frozen_string_literal: true

# Model for ratings. Ratings are given to posts by users.
# Ratings have a value that must be between 1 and 5.
# Each user can rate a specific post only once.
class Rating < ApplicationRecord
  # Associations
  belongs_to :post  # The post that is being rated.
  belongs_to :user  # The user who gives the rating.

  # Validations
  validates :value, presence: true, inclusion: { in: 1..5 } # Ensures rating value is within the allowed range.

  validates :user_id, uniqueness: { scope: :post_id, message: I18n.t('rate_once_error') }
  # Ensures a user can rate a specific post only once.
end
