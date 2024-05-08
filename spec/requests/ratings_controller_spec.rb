# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Ratings API', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:post_item) { FactoryBot.create(:post, user:) }
  let(:valid_attributes) { { post_id: post_item.id, user_id: user.id, value: 5 } }

  describe 'POST /ratings', :n_plus_one do
    context 'when the request is valid' do
      it 'creates a new rating' do
        expect do
          post ratings_path, params: valid_attributes.to_json, headers: { 'Content-Type': 'application/json' }
        end.to change(Rating, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to have_key('average_rating')
      end
    end

    context 'when the request is a duplicate rating' do
      before { post ratings_path, params: valid_attributes.to_json, headers: { 'Content-Type': 'application/json' } }

      it 'does not create a duplicate rating and returns status code unprocessable_entity' do
        expect do
          post ratings_path, params: valid_attributes.to_json, headers: { 'Content-Type': 'application/json' }
        end.not_to change(Rating, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end
  end
end
