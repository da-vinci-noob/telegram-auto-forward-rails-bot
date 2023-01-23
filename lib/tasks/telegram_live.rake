namespace :telegram_live do
  desc 'Continuously run telegram bot in developmemt'
  task run: :environment do
    Rake::Task['telegram:bot:poller'].invoke
  rescue Telegram::Bot::Error, OpenSSL::SSL::SSLError
    puts 'An Error Occured retrying'
    sleep 10
    retry
  end
end
