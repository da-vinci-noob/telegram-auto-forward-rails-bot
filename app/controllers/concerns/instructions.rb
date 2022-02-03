# Module Have all the long instruction at one place
module Instructions
  extend ActiveSupport::Concern

  def start!(command = nil, *other_words)
    respond_with :message, text: (I18n.t 'instructions.start', first_name: @first_name)
  end

  def bitly!
    respond_with :message, text: (I18n.t 'instructions.bitly', first_name: @first_name), parse_mode: :markdown
  end

  def help!
    respond_with :message, text: (I18n.t 'instructions.help', first_name: @first_name), parse_mode: :markdown
  end
end
