# frozen_string_literal: true

class IpAnalysisService
  def initialize; end

  def call
    ips = Post.select(:ip).group(:ip).having('COUNT(DISTINCT user_id) > 1').pluck(:ip)
    Post.includes(:user).where(ip: ips).group_by(&:ip).transform_values do |posts|
      posts.map { |post| post.user.login }.uniq
    end
  end
end
