class BaseResponse
  attr_reader :response

  def initialize(response)
    @response = response
  end

  def body
    @body ||= JSON.parse(response.body)
  end

  def code
    response.code
  end

  def stock_available?
    raise NotImplementedError, 'Implement in subclass'
  end

  def log_available!(notifier)
    raise StandardError, 'Missing notifier in response' unless notifier
    notifier.enqueue_messages! "\n\n\n==="
    notifier.enqueue_messages! "== Available #{self.class} Body ==" if stock_available?
    notifier.enqueue_messages! body if stock_available?
    notifier.enqueue_messages! "\n\n\n==="
  end
end