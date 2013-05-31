class ReplyConsumer < Chizuru::Consumer
  def initialize(twit_data, screen_name)
    super()
    case twit_data
    when IO
      @responses = twit_data.readlines
    when String
      if File.exist?(twit_data)
        open(twit_data, 'r:utf-8') do |file|
          @responses = file.readlines
        end
      else
        @responses = twit_data.lines
      end
    else
      raise ArgumentError
    end
    raise ArgumentError if (!screen_name || screen_name.empty?)
    @screen_name = screen_name
  end

  def receive(data)
    return unless data['text']
    if data['text'] =~ /^@#{@screen_name} /
      reply = {status: "@#{data['user']['screen_name']} #{@responses.sample}", in_reply_to: data}
      deliver(reply)
    end
  end
end
