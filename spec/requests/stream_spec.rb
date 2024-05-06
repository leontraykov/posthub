# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Integration Test for user, post, and rating creation', type: :request do
  it 'successfully goes through the flow of creating user, post, and rating' do
    # User creation
    user_attributes = { user: { login: 'testuser' } }
    post users_path, params: user_attributes
    expect(response).to have_http_status(:created)
    user = JSON.parse(response.body)

    # Post creation
    post_attributes = { post: { title: 'Test Post', body: 'This is a test body', login: user['login'],
                                ip: '192.168.1.1' } }
    post posts_path, params: post_attributes
    expect(response).to have_http_status(:created)
    post = JSON.parse(response.body)

    # Rate the post
    rating_attributes = { rating: { post_id: post['id'], user_id: user['id'], value: 5 } }
    post ratings_path, params: rating_attributes
    expect(response).to have_http_status(:created)

    # Rate the post again
    post ratings_path, params: rating_attributes
    expect(response).to have_http_status(:unprocessable_entity)

    # Getting the top of posts
    get top_posts_path, params: { n: 1 }
    expect(response).to be_successful
    results = JSON.parse(response.body)
    expect(results.first['average_rating']).to eq('5.0')
  end
end
