class TwitterDeliverer
  def initialize(cred)
    @credential = cred
  end

  def deliver(data)
    return unless data[:status]
    opts = {status: data[:status]}
    if data[:in_reply_to]
      opts[:in_reply_to_status_id] = data[:in_reply_to]['id']
    end
    @credential.access_token.post(
      '/statuses/update.json', opts)
  end
end

