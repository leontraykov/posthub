# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:post) }

  describe 'validations' do
    context 'value validations' do
      it 'ensures inclusion within the allowed range (1 to 5)' do
        invalid_rating = FactoryBot.build(:rating, user:, post:, value: 6)
        expect(invalid_rating).not_to be_valid
        expect(invalid_rating.errors[:value]).to include('is not included in the list')
      end

      it 'checks presence of value' do
        missing_value_rating = FactoryBot.build(:rating, user:, post:, value: nil)
        expect(missing_value_rating).not_to be_valid
        expect(missing_value_rating.errors[:value]).to include("can't be blank")
      end
    end

    context 'uniqueness validation' do
      it 'does not allow a user to rate the same post more than once' do
        FactoryBot.create(:rating, user:, post:, value: 5)
        duplicate_rating = FactoryBot.build(:rating, user:, post:, value: 3)
        duplicate_rating.valid?
        expect(duplicate_rating.errors[:user_id]).to include('User has already rated this post')
      end
    end
  end
end
