# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    association :user
    title { Faker::Lorem.sentence(word_count: 3) }
    body { Faker::Lorem.sentence(word_count: 5) }
    ip { Faker::Internet.ip_v4_address }
  end
end
