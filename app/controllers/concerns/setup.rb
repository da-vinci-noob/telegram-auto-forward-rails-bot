# Module Have all the long instruction at one place
module Setup
  extend ActiveSupport::Concern

  def amazon!(answer = nil, *other_words)
    return respond_with :message, text: (I18n.t 'setup.invalid', param: 'Amazon Tracking ID') if answer.nil?

    configure_amazon(answer)
    respond_with :message, text: (I18n.t 'setup.amazon', amzn_id: answer), parse_mode: :markdown
  end

  def flipkart!(answer = nil, *other_words)
    return respond_with :message, text: (I18n.t 'setup.invalid', param: 'Flipkart Tracking ID') if answer.nil?

    configure_flipkart(answer)
    respond_with :message, text: (I18n.t 'setup.flipkart', fkrt_id: answer), parse_mode: :markdown
  end

  def bitly!(answer = nil, *other_words)
    return respond_with :message, text: (I18n.t 'setup.invalid', param: 'Bitly Access Token') if answer.nil?

    configure_bitly(answer)
    respond_with :message, text: (I18n.t 'setup.bitly', bitly_id: answer), parse_mode: :markdown
  end

  def forward!(answer = nil, *other_words)
    return respond_with :message, text: (I18n.t 'setup.invalid', param: 'Channel Username (@ included)') if answer.nil?

    configure_forward(answer)
    respond_with :message, text: (I18n.t 'setup.forward', channel: answer), parse_mode: :markdown
  end

  def previews!(answer = nil, *other_words)
    return respond_with :message, text: (I18n.t 'setup.invalid', param: 'preview') if answer.nil?

    res = answer == 'disable' ? 'disabled' : 'enabled'
    configure_previews(res)
    respond_with :message, text: (I18n.t 'setup.previews', input: res), parse_mode: :markdown
  end

  def delete!(*keywords)
    return respond_with :message, text: (I18n.t 'setup.invalid', param: 'delete') if keywords.blank?

    configure_delete(keywords)
    respond_with :message, text: (I18n.t 'setup.delete', content: keywords.join(', ')), parse_mode: :markdown
  end

  def show_deleted!(*answer)
    contents = Cache.redis.smembers("#{@chat_id}:delete")
    respond_with :message, text: (I18n.t 'setup.deleted_contents', contents: contents.join(', '))
  end

  private

  def configure_amazon(amzn_id)
    Cache.redis.set("#{@chat_id}:amzn_id", amzn_id)
  end

  def configure_flipkart(fkrt_id)
    Cache.redis.set("#{@chat_id}:fkrt_id", fkrt_id)
  end

  def configure_bitly(bitly_id)
    Cache.redis.set("#{@chat_id}:bitly_id", bitly_id)
  end

  def configure_forward(channel)
    Cache.redis.set("#{@chat_id}:forward", channel)
  end

  def configure_previews(previews)
    Cache.redis.set("#{@chat_id}:previews", previews)
  end

  def configure_delete(keywords)
    Cache.redis.sadd("#{@chat_id}:delete", keywords)
  end
end
