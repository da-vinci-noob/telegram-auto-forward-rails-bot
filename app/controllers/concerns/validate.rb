# Validations
module Validate
  extend ActiveSupport::Concern

  def validate_bitly?
    Cache.redis.exists?("#{@chat_id}:bitly_id")
  end

  def validate_flipkart?
    Cache.redis.exists?("#{@chat_id}:fkrt_id")
  end

  def validate_amazon?
    Cache.redis.exists?("#{@chat_id}:amzn_id")
  end

  def validate_all?
    validate_flipkart? && validate_amazon?
  end
end
