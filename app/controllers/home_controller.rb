class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :fetch_user_details, only: [:index]

  def index; end

  def update
    if params[:id] == 'toggle'
      current_preview = Cache.redis.get("#{current_user.telegram_user_id}:previews") || 'disabled'

      previews_to_set = current_preview == 'disabled' ? 'enabled' : 'disabled'

      Cache.redis.set("#{current_user.telegram_user_id}:previews", previews_to_set)
    else
      Cache.redis.set("#{current_user.telegram_user_id}:#{params[:id]}", params[:val])
    end
    redirect_to home_path
  end

  private

  def fetch_user_details
    @user = {
      id: current_user.telegram_user_id,
      amazon_id: (Cache.redis.get "#{current_user.telegram_user_id}:amzn_id") || 'Not Set',
      flipkart_id: (Cache.redis.get "#{current_user.telegram_user_id}:fkrt_id") || 'Not Set',
      bitly_key: (Cache.redis.get "#{current_user.telegram_user_id}:bitly_id") || 'Not Set',
      deleted_keywords: Cache.redis.smembers("#{current_user.telegram_user_id}:delete"),
      previews: (Cache.redis.get "#{current_user.telegram_user_id}:previews") || 'Not Set'
    }
  end
end
