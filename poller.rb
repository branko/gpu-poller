load 'setup.rb'

# You need to create a file called secrets.rb in the root directory
# with a constant called WEBHOOK_URL which corresponds to the 
# Webhook URL for your slack workspace
load 'secrets.rb'

class CanadaComputersPoller
  attr_reader :notifier

  CODE_BY_MANUFACTURER = {
    gigabyte: 183101,
    evga: 183500,
  }

  MANUFACTURER_BY_CODE = CODE_BY_MANUFACTURER.invert

  def initialize
    @notifier = SlackNotifier.new
  end

  def poll
    start!

    codes.each(&-> (c) { process_code(c) })

    finish!
  end

  private
  
  def process_code(code)
    Alert.info "Fetching #{MANUFACTURER_BY_CODE[code]}"
    response = CanadaComputersResponse.new(get(build_url(code)))

    Alert.info "Responded with code #{response.code}"

    response.stock_available? ? notify_available!(code) : Alert.warn('Unavailable')
  end

  def start!
    notifier.message!("\n\n\n🚨 #{time}: Beginning polling!")
  end

  def finish!
    notifier.flush_and_send_queue!
    notifier.message!("\n😴 Finished polling")
  end

  def time
    Time.now.strftime("%I:%M %p")
  end

  def get(url)
    HTTParty.get(url)
  end

  def codes
    CODE_BY_MANUFACTURER.values
  end

  def build_url(code)
    "https://www.canadacomputers.com/product_info.php?ajaxstock=true&itemid=#{code}"
  end

  def notify_available!(code)
    notifier.enqueue_messages!("‼️ It's available!* manufacturer: #{MANUFACTURER_BY_CODE[code]}")
  end
end

CanadaComputersPoller.new.poll