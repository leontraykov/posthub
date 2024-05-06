# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    context 'when login is not provided' do
      it 'validates presence of login' do
        user = User.new(login: nil)
        expect(user.valid?).to be_falsey
        expect(user.errors[:login]).to include("can't be blank")
      end
    end

    context 'when login is not unique' do
      before { FactoryBot.create(:user, login: 'unique_login') }

      it 'validates uniqueness of login' do
        new_user = User.new(login: 'unique_login')
        new_user.valid?
        expect(new_user.errors[:login]).to include('has already been taken')
      end
    end
  end
end
