class AdministratorController < ApplicationController
  before_action :authenticate_admin!

  def index
    @user_values = Hash.new { |h, k| h[k] = [] }

    Cache.redis.keys.each do |item|
      key, value = item.split(':')
      @user_values[key.to_i] << value
    end
  end
end
