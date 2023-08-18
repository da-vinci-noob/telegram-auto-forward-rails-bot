# Module Have all the long instruction at one place
module Instructions
  extend ActiveSupport::Concern

  def start!(command = nil, *other_words)
    respond_with :message, text: (I18n.t 'instructions.start', first_name: @first_name)
  end

  def bitly_setup!(*words)
    respond_with :message, text: (I18n.t 'instructions.bitly', first_name: @first_name), parse_mode: :markdown
    if words.size.positive?
      respond_with :message, text: (I18n.t 'instructions.bitly_command'), parse_mode: :markdown
    end
  end

  def help!
    respond_with :message, text: (I18n.t 'instructions.help', first_name: @first_name), parse_mode: :markdown
  end
end
