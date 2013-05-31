class PassThroughConsumer < Chizuru::Consumer
  def receive(data)
    deliver(data)
  end
end
