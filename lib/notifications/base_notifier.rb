class BaseNotifier
  attr_reader :messages

  def initialize
    @messages = []
  end

  def enqueue_messages!(message)
    @messages << message
  end

  def flush_and_send_queue!
    message!(build_message_from_queue)
  end

  def message!
    puts "Implement in subclass"
  end
end