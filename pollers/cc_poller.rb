load 'setup.rb'

class CanadaComputersPoller < BasePoller
  def initialize
    @manufacturer_klass = CanadaComputersManufacturer
    @prefix = 'cc'
    super
  end

  def poll
    super do
      check_search!
    end
  end

  def start!
    notifier.message!("🚨 #{time}: Checking CC via scraping and API!")
  end

  private

  def check_search!
    start_scraping!
    Alert.info "Scraping search!"

    CanadaComputersScraper.search_in_stock? do |keywords|
      notifier.enqueue_messages!("In stock by search for [#{keywords}]")
    end

    CanadaComputersScraper.search_in_stock?(keywords: '3060ti') do |keywords|
      notifier.enqueue_messages!("In stock by search for [#{keywords}]")
    end
  end
  
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
end

CanadaComputersPoller.new.poll
