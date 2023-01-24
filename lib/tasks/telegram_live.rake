namespace :telegram_live do
  desc 'Continuously run telegram bot in developmemt'
  task run: :environment do
    Rake::Task['telegram:bot:poller'].invoke
  rescue Telegram::Bot::Error, OpenSSL::SSL::SSLError, SocketError
    puts 'An Error Occured retrying'
    sleep 20
    retry
  end
end
