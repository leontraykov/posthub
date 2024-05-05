# frozen_string_literal: true

# Migration to create the posts table.
# Each post is linked to a user and has a title, body, and IP address.
class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false  # Title of the post, must be present.
      t.text :body, null: false     # Body of the post, must be present.
      t.string :ip, null: false     # IP address from which the post was created, must be present.
      t.references :user, null: false, foreign_key: true # Link to the user who created the post.

      t.timestamps # Automatically adds created_at and updated_at.
    end
    add_index :posts, :ip # Index on IP address for faster query performance.
    add_index :posts, %i[user_id ip] # Composite index for queries involving user and IP.
  end
end
