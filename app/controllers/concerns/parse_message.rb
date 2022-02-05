module ParseMessage
  extend ActiveSupport::Concern

  def filter_message
    to_delete = Cache.redis.smembers("#{@chat_id}:delete")
    @message_content.gsub!(/#{Regexp.union(to_delete).source}/i, '') unless to_delete.empty?
  end

  def disable_previews
    Cache.redis.get("#{@chat_id}:previews") == 'disable'
  end
end
