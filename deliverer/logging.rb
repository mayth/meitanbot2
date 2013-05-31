class LoggingDeliverer
  attr_accessor :out
  def initialize(out)
    @out = out
  end

  def deliver(data)
    @out.puts(data.inspect)
  end
end
