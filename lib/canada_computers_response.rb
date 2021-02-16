class CanadaComputersResponse
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
    # avail seems to be in store quantity
    # avail2 is online quantity
    body['avail'] != 0 || body['avail2'] != 'NO AVAILABLE'
  end
end
