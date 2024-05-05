# frozen_string_literal: true

# Migration to create the ratings table.
# Ratings link a user and a post with a value indicating the rating.
class CreateRatings < ActiveRecord::Migration[7.1]
  def change
    create_table :ratings do |t|
      t.references :post, null: false, foreign_key: true  # Reference to the post being rated.
      t.references :user, null: false, foreign_key: true  # Reference to the user giving the rating.
      t.integer :value, null: false # Numeric value of the rating, must be present.

      t.timestamps # Automatically adds created_at and updated_at.
    end
    add_index :ratings, %i[post_id user_id], unique: true # Unique index to prevent duplicate ratings.
  end
end
