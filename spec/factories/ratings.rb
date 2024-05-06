# frozen_string_literal: true

FactoryBot.define do
  factory :rating do
    association :post
    association :user
    value { Faker::Number.between(from: 1, to: 5) } # генерация значения от 1 до 5
  end
end
