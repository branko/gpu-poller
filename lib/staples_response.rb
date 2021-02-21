class StaplesResponse < BaseResponse
  def stock_available?
    body['availability'][0]['available_quantity'] > 0
  end
end