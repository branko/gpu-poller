class CanadaComputersResponse < BaseResponse
  def stock_available?
    # avail seems to be in store quantity
    # avail2 is online quantity
    avail? || avail2?
  end

  private

  def avail?
    body['avail'] && body['avail'] != 0
  end

  def avail2?
    body['avail2'] && body['avail2'] != 'NO AVAILABLE'
  end
end
