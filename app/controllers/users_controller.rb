# frozen_string_literal: true

# UsersController manages user creation within the application.
# It includes actions to handle user data sent through API requests.
class UsersController < ApplicationController
  # POST /users
  # Creates a new user with a unique login.
  def create
    @user = User.new(user_params) # Initialize a new user instance with parameters.

    if @user.save # Attempt to save the new user to the database.
      render json: @user, status: :created # On success, return the user data with status 'created'.
    else
      render json: @user.errors, status: :unprocessable_entity # On failure, return the errors.
    end
  end

  private

  # Strong parameters to protect against unwanted parameters,
  # allowing only the 'login' parameter to be passed in.
  def user_params
    params.require(:user).permit(:login)
  end
end
