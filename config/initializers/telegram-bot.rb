Telegram.bots_config = {
  default: {
    token: ENV.fetch('BOT_TOKEN'),
    username: ENV.fetch('BOT_USERNAME'), # to support commands with mentions (/help@ChatBot)
    async: true
  }
}
