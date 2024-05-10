# frozen_string_literal: true

class PostCreationService
  def initialize(user, post_params)
    @user = user
    @post_params = post_params
  end

  def call
    post = @user.posts.build(@post_params)
    if post.save
      { status: :created, json: post }
    else
      { status: :unprocessable_entity, json: post.errors.full_messages }
    end
  end
end
