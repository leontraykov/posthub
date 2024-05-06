# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts API', type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe 'POST /posts' do
    let(:valid_attributes) { { post: { title: 'Test Title', body: 'Test Body', login: user.login, ip: '127.0.0.1' } } }
    let(:invalid_attributes) { { post: { title: '', body: '', login: user.login, ip: '' } } }

    it 'creates a new post with valid attributes' do
      expect { post posts_path, params: valid_attributes }
        .to change(Post, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(json['title']).to eq('Test Title')
    end

    it 'does not create a post with invalid attributes' do
      post posts_path, params: { post: { title: '', body: '', login: user.login, ip: '127.0.0.1' } }
      expect(response).to have_http_status(:unprocessable_entity)
      errors = JSON.parse(response.body)['errors']
      expect(errors['title']).to include("can't be blank")
      expect(errors['body']).to include("can't be blank")
    end
  end

  describe 'GET /posts/:id' do
    let(:post) { FactoryBot.create(:post, user:) }

    it 'retrieves a specific post by id' do
      get post_path(post)
      expect(response).to be_successful
      expect(json).to include('title' => post.title, 'body' => post.body)
    end
  end

  context 'Complex queries' do
    describe 'GET /top_posts' do
      let!(:posts) { FactoryBot.create_list(:post, 5, user:) }

      before { posts.each { |post| FactoryBot.create(:rating, post:, value: 5) } }

      it 'returns top posts based on ratings' do
        get top_posts_path, params: { n: 5 }
        expect(response).to be_successful
        expected = posts.first(5).map do |post|
          { 'id' => post.id, 'title' => post.title, 'average_rating' => '5.0', 'body' => post.body }
        end
        expect(JSON.parse(response.body)).to match_array(expected)
      end
    end

    describe 'GET /ips_with_multiple_authors' do
      let!(:other_user) { FactoryBot.create(:user) }
      let!(:post1) { FactoryBot.create(:post, user:, ip: '192.168.1.1') }
      let!(:post2) { FactoryBot.create(:post, user: other_user, ip: '192.168.1.1') }

      it 'returns IPs with posts from multiple authors' do
        get '/ips_with_multiple_authors'
        expect(response).to be_successful
        expect(json['192.168.1.1']).to include(user.login, other_user.login)
      end
    end
  end
end
