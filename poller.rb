load 'setup.rb'

class Manufacturer
  attr_reader :code, :name, :link, :price
  def initialize(code, name, link, price)
    @code = code
    @name = name
    @link = link
    @price = price
  end
end

class CanadaComputersPoller
  attr_reader :notifier

  MANUFACTURER_BY_CODE = {
    183101 => 'gigabyte', # $779
    183500 => 'evga', # $789
    183636 => 'asus1', # $749
    183638 => 'asus2', # $799
    183208 => 'msi', # $819
  }

  CODE_BY_MANUFACTURER = MANUFACTURER_BY_CODE.invert

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
    MANUFACTURER_BY_CODE.keys
  end

  def build_url(code)
    "https://www.canadacomputers.com/product_info.php?ajaxstock=true&itemid=#{code}"
  end

  def notify_available!(code)
    notifier.enqueue_messages!("‼️ It's available!* manufacturer: #{MANUFACTURER_BY_CODE[code]}")
  end
end

CanadaComputersPoller.new.poll