class CanadaComputersResponse < BaseResponse
  def stock_available?
    # avail seems to be in store quantity
    # avail2 is online quantity
    body['avail'] != 0 || body['avail2'] != 'NO AVAILABLE'
  end
end
