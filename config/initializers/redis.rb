# frozen_string_literal: true

# Creating global redis object
module Cache
  class << self
    def redis
      @redis ||= Redis.new(url: (ENV['REDIS_URL'] || 'redis://127.0.0.1:6379'))
    end
  end
end
