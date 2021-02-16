load 'setup.rb'

class Manufacturer
  attr_reader :code, :name, :price
  def initialize(code, name, price)
    @code = code
    @name = name
    @price = price
  end

  def url
    "https://www.canadacomputers.com/product_info.php?ajaxstock=true&itemid=#{code}"
  end

  def link_to_buy
    "https://www.canadacomputers.com/product_info.php?cPath=43_557_559&item_id=#{code}"
  end
end

class CanadaComputersPoller
  attr_reader :notifier

  MANUFACTURERS = [
    Manufacturer.new(183101, 'Gigabyte', '$779'),
    Manufacturer.new(183500, 'EVGA', '$789'),
    Manufacturer.new(183636, 'ASUS', '$749'),
    Manufacturer.new(183638, 'ASUS TUF', '$799'),
    Manufacturer.new(183208, 'MSI', '$819'),
  ]

  def initialize
    @notifier = SlackNotifier.new
  end

  def poll
    start!

    MANUFACTURERS.each(&-> (m) { process_code(m) })

    finish!
  end

  private
  
  def process_code(manufacturer)
    code = manufacturer.code
    url = manufacturer.url
    Alert.info "Fetching #{manufacturer.name}"
    response = CanadaComputersResponse.new(get(url))

    Alert.info "Responded with code #{response.code}"

    response.stock_available? ? notify_available!(manufacturer) : Alert.warn('Unavailable')
  end

  def start!
    notifier.message!("#{'-' * 40}\n🚨 #{time}: Beginning polling!")
  end

  def finish!
    notifier.flush_and_send_queue!
    notifier.message!("😴 Finished polling\n#{'-' * 40}")
  end

  def time
    Time.now.strftime("%I:%M %p")
  end

  def get(url)
    HTTParty.get(url)
  end

  def notify_available!(manufacturer)
    slack_link = "<#{manufacturer.link_to_buy}|#{manufacturer.name}>"
    message = "‼️ *It's available!* link: #{slack_link}\n"
    notifier.enqueue_messages!(message)
  end
end

CanadaComputersPoller.new.poll