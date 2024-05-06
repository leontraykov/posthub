# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validations' do
    context 'when required attributes are missing' do
      it 'validates presence of title' do
        post = Post.new(title: nil, body: 'Sample Body', ip: '127.0.0.1')
        expect(post.valid?).to be_falsey
        expect(post.errors[:title]).to include("can't be blank")
      end

      it 'validates presence of body' do
        post = Post.new(title: 'Sample Title', body: nil, ip: '127.0.0.1')
        expect(post.valid?).to be_falsey
        expect(post.errors[:body]).to include("can't be blank")
      end

      it 'validates presence of ip' do
        post = Post.new(title: 'Sample Title', body: 'Sample Body', ip: nil)
        expect(post.valid?).to be_falsey
        expect(post.errors[:ip]).to include("can't be blank")
      end
    end
  end
end
