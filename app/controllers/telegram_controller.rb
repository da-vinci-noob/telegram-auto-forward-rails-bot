class TelegramController < Telegram::Bot::UpdatesController
  include Instructions
  include Validate
  include Setup
  include Affiliate
  include ParseMessage

  # use callbacks like in any other controller
  around_action :with_locale
  before_action :set_variables

  # Every update has one of: message, inline_query, chosen_inline_result,
  # callback_query, etc.
  # Define method with the same name to handle this type of update.
  def message(message)
    # store_message(message['text'])
    @message_content = message['text']&.gsub('<', '&lt;')&.gsub('>', '&gt;') || ''
    parse_inline_entitites(message['entities']) if message['entities']
    if @message_content.match? /http/i
      process_affiliate
      filter_message
      send_to_channel
    else
      invalid_message
    end
    Rails.logger.debug(@message_content)
    reply_with :message, text: @message_content, disable_web_page_preview: disable_previews, parse_mode: :html
  rescue Telegram::Bot::Error => e
    reply_with :message, text: 'An Error occurred with the Bot'
  rescue SocketError => e
    reply_with :message, text: "An Error occurred while processing your links: #{e.message}"
  end

  # For the following types of updates commonly used params are passed as arguments,
  # full payload object is available with `payload` instance method.
  #
  #   message(payload)
  #   inline_query(query, offset)
  #   chosen_inline_result(result_id, query)
  #   callback_query(data)

  # Define public methods ending with `!` to handle commands.
  # Command arguments will be parsed and passed to the method.
  # Be sure to use splat args and default values to not get errors when
  # someone passed more or less arguments in the message.
  # def start!(word = nil, *other_words)
  #   # do_smth_with(word)
  #
  #   # full message object is also available via `payload` instance method:
  #   # process_raw_message(payload['text'])
  #
  #   # There are `chat` & `from` shortcut methods.
  #   # For callback queries `chat` is taken from `message` when it's available.
  #   response = from ? "Hello #{from['username']}!" : 'Hi there!'
  #
  #   # There is `respond_with` helper to set `chat_id` from received message:
  #   respond_with :message, text: response
  #
  #   # `reply_with` also sets `reply_to_message_id`:
  #   # reply_with :photo, photo: File.open('party.jpg')
  # end

  private

  def with_locale(&block)
    I18n.with_locale(locale_for_update, &block)
  end

  def locale_for_update
    if from
      # locale for user
    elsif chat
      # locale for chat
    end
  end

  def set_variables
    @first_name = chat['first_name']
    @chat_id = chat['id']
    @username = chat['username']
  end

  def process_affiliate
    @message_content = I18n.t 'no_setup', first_name: @first_name unless validate_all?

    process = Process.new(@chat_id)
    urls = URI.extract(@message_content, %w[http https])
    urls.each do |url|
      process.individual_url(url)
      @message_content.sub!(url, process.updated_url)
    end
    @success = true unless process.error
  end

  def invalid_message
    @message_content = "I have no idea what #{@message_content} means. \nYou can view available commands with /help"
  end

  def send_to_channel
    channel_id = Cache.redis.get("#{@chat_id}:forward")
    return unless channel_id && @success

    begin
      bot.send_message(chat_id: channel_id, text: @message_content, disable_web_page_preview: disable_previews, parse_mode: :html)
    rescue Telegram::Bot::Error => e
      message = if e.message.include? 'bot is not a member'
        'Please Double check Channel Username if you have added the Bot as an Admin to the Channel.'
      else
        'Please enter correct Channel Username with "@" prefix '
      end
      respond_with :message, text: message
    rescue StandardError
      respond_with :message, text: t('errors.channel_forward')
    end
  end

  def parse_inline_entitites(entities)
    offset_fix = 0
    entities.each do |entity|
      offset = entity['offset'] + offset_fix
      text = format_single_entity(entity, offset)
      next if text.nil?

      @message_content[offset, entity['length']] = text
      offset_fix += text.size - entity['length']
    end
  rescue IndexError
    reply_with :message, text: t('errors.formatting')
  end

  def format_single_entity(entity, offset)
    case entity['type']
    when 'text_link'
      "<a href='#{entity['url']} '>#{@message_content[offset, entity['length']]}</a>"
    when 'bold'
      "<b>#{@message_content[offset, entity['length']]}</b>"
    when 'code'
      "<code>#{@message_content[offset, entity['length']]}</code>"
    when 'italic'
      "<i>#{@message_content[offset, entity['length']]}</i>"
    end
  end
end
