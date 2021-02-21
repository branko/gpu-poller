class BaseResponse
  attr_reader :response

  def initialize(response)
    @response = response
  end

  def body
    JSON.parse(response.body)
  end

  def code
    response.code
  end

  def stock_available?
    raise NotImplementedError, 'Implement in subclass'
  end
end