# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  describe 'POST /users' do
    let(:valid_attributes) { { user: { login: 'unique_login' } } }

    context 'when the request is valid' do
      it 'creates a new user and returns status created' do
        expect do
          post '/users', params: valid_attributes
        end.to change(User, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(json['login']).to eq('unique_login')
      end
    end

    context 'when the request is invalid due to empty login' do
      it 'does not create a new user and returns status unprocessable_entity' do
        expect do
          post '/users', params: { user: { login: '' } }
        end.to change(User, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("can't be blank")
      end
    end

    context 'when the login is not unique' do
      before { FactoryBot.create(:user, login: 'unique_login') }

      it 'does not allow creating a user with a duplicate login' do
        expect do
          post '/users', params: valid_attributes
        end.to change(User, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('has already been taken')
      end
    end
  end
end
