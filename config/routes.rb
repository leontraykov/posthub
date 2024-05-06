# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: [:create]

  resources :posts, only: %i[create show] do
    collection do
      get 'top', to: 'posts#top' # Getting N top posts by average rating
    end
  end

  resources :ratings, only: [:create]

  # Getting IP list, from which posts were created by more than one author
  get 'ips_with_multiple_authors', to: 'posts#ips_with_multiple_authors'
end
