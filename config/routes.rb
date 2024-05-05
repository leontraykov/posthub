# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'api#info'

  resources :users, only: [:create]

  resources :posts, only: %i[create show] do
    collection do
      get 'top', to: 'posts#top' # Получение топ N постов по среднему рейтингу
    end
  end

  resources :ratings, only: [:create]

  # Получение списка IP адресов, с которых были созданы посты несколькими разными авторами
  get 'ips_with_multiple_authors', to: 'posts#ips_with_multiple_authors'
end
