require 'paint'
require 'httparty'

load 'secrets.rb'

def msg(message, color=:red)
  puts Paint[message, color]
end

# gigabyte 3070 $779.00
CODE_BY_MANUFACTURER = {
  gigabyte: 183101,
  evga: 183500,
}

MANUFACTURER_BY_CODE = CODE_BY_MANUFACTURER.invert

codes = CODE_BY_MANUFACTURER.values

def notify_available!
  payload='{"text": "OMG"}'
  msg("AVAILABLE!", :green)
  resp = HTTParty.post(WEBHOOK_URL, body: payload)
  puts resp
end

# Canada Computers URL template
codes.each do |code|
  msg "Getting #{MANUFACTURER_BY_CODE[code]}", :yellow
  url = "https://www.canadacomputers.com/product_info.php?ajaxstock=true&itemid=#{code}"
  msg url
  response = HTTParty.get(url)

  msg "Responded with code #{response.code}"

  body = JSON.parse(response.body)
  body['avail'] == 1 ? msg('Unavailable') : notify_available!
  puts "\n"
end