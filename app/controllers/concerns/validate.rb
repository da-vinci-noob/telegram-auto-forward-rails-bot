# Validations
module Validate
  extend ActiveSupport::Concern

  def self.bitly
    Cache.redis.exists?("#{@chat_id}:bitly_id")
  end

  def self.flipkart
    Cache.redis.exists?("#{@chat_id}:fkrt_id")
  end

  def self.amazon
    Cache.redis.exists?("#{@chat_id}:amzn_id")
  end

  def self.all
    bitly && flipkart && amazon
  end
end
