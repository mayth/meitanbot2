require 'chizuru'
require 'chizuru/user_stream'

['deliverer', 'consumer'].each do |dir|
  Dir.glob("./#{dir}/*.rb") do |s|
    require_relative s
  end
end

log_io = open('stream.log', 'a:utf-8')
#log_io = $stdout

SCREEN_NAME = 'meitanbot'

bot = Chizuru::Bot.configure '.credential.yaml' do
  source Chizuru::UserStream.new(provider, credential, SCREEN_NAME, 'certificate', "meitanbot/2.0 (based on Chizuru/#{Chizuru::VERSION})")

  twit_deliv = TwitterDeliverer.new(credential)
  log_deliv = LoggingDeliverer.new(log_io)

  consumer PassThroughConsumer do
    deliverer log_deliv
  end

  consumer MeitanConsumer.new('reply_meitan.txt', SCREEN_NAME) do
    deliverer twit_deliv
  end

  consumer ReplyConsumer.new('reply.txt', SCREEN_NAME) do
    deliverer twit_deliv
  end
end

begin
  puts '===== starting ====='
  #puts '=== post first message ==='
  #credential.access_token.post(
  #  '/statuses/update.json', {status: "hi. (meitanbot2 is starting at #{Time.now})"})
  puts '=== starting bot ==='
  bot.start
  while true; end
ensure
  puts '===== exiting ====='
  #puts '=== post exiting message ==='
  #credential.access_token.post(
  #  '/statuses/update.json', {status: "bye. (meitanbot2 is terminating at #{Time.now})"})
  log_io.close
end
