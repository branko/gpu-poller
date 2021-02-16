load 'setup.rb'

class CanadaComputersPoller
  attr_reader :notifier

  MANUFACTURERS = [
    Manufacturer.new(183101, 'Gigabyte', '$779'),
    Manufacturer.new(183500, 'EVGA', '$789'),
    Manufacturer.new(183636, 'ASUS', '$749'),
    Manufacturer.new(183638, 'ASUS TUF', '$799'),
    Manufacturer.new(183208, 'MSI', '$819'),
    # Test manufacturer, this is probably in stock
    # Manufacturer.new(139783, 'Test manufacturer', '$10000')
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

    response.stock_available? ?
      notify_available!(manufacturer) { |link| "‼️ *#{code}: It's available locally!* link: #{link}\n" } :
      Alert.warn('Unavailable by API')

    scraper = CanadaComputersScraper.new(code)
    scraper.in_stock_by_scraping? ?
      notify_available!(manufacturer) { |link| "‼️ *#{code}: It's available somewhere!* link: #{link}\n" } :
      Alert.warn('Unavailable by scraping')
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
    message = yield(slack_link)
    notifier.enqueue_messages!(message)
  end
end

CanadaComputersPoller.new.poll