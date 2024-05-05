# frozen_string_literal: true

# Migration to create the users table.
# Users are uniquely identified by their login.
class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :login, null: false # Login must be present and is unique.

      t.timestamps # Automatically adds created_at and updated_at.
    end
    add_index :users, :login, unique: true # Ensures that the login is unique across all users.
  end
end
