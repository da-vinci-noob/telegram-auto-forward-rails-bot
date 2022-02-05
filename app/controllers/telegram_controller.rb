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
    @message_content = message['text']
    if @message_content.match? /http/i
      process_affiliate
      filter_message
    else
      invalid_message
    end
    reply_with :message, text: @message_content, disable_web_page_preview: disable_previews
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
    return 'Please Setup the Bot first' unless validate_all?

    process = Process.new(@chat_id)
    urls = URI.extract(@message_content, %w[http https])
    urls.each do |url|
      process.individual_url(url)
      @message_content.sub!(url, process.updated_url)
    end
  end

  def invalid_message
    @message_content = "I have no idea what #{@message_content} means. \nYou can view available commands with /help"
  end
end
