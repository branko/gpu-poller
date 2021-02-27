class BaseNotifier
  attr_reader :messages

  def initialize
    @messages = []
    @notify_user = false
  end
  
  def notify_user!
    @notify_user = true
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