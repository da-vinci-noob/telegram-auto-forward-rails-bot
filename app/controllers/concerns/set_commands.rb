# Module to set commands to bot
module SetCommands
  extend ActiveSupport::Concern

  def set_commands!(*other_words)
    Telegram.bot.set_my_commands(commands)
    respond_with :message, text: (I18n.t 'set_commands', first_name: @first_name)
  rescue
    respond_with :message, text: (I18n.t 'errors.set_commands', first_name: @first_name)
  end

  def commands
    {
      commands: [
        { command: 'start', description: 'Starts the bot' },
        { command: 'help', description: 'View available commands with description' },
        { command: 'amazon', description: 'add amazon tracking id' },
        { command: 'flipkart', description: 'add flipkart tracking id' },
        { command: 'bitly_setup', description: 'show Bit.ly setup procedure' },
        { command: 'bitly', description: 'add bitly access token' },
        { command: 'previews', description: 'For disabling Link Previews' },
        { command: 'forward', description: 'Add @channel to forward messages to' },
        { command: 'delete', description: 'Add word to delete from return message' },
        { command: 'show_deleted', description: 'Show Your words to delete' },
        { command: 'remove_deleted', description: 'Remove a keyword from delete list' },
        { command: 'user_profile', description: 'Show Your Complete Configuration' }
      ], language_code: 'en'
    }
  end
end
