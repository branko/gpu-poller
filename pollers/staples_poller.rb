load 'setup.rb'

class StaplesResponse

end

class StaplesPoller < BasePoller
  def initialize
    @manufacturer_klass = StaplesManufacturer
    @prefix = 'staples'
    super
  end

  def start!
    notifier.message! "🚨 #{time}: Checking Staples via API..."
  end

  private
  
  def process_code(manufacturer)
    code = manufacturer.code
    url = manufacturer.url
    Alert.info "Fetching #{manufacturer.name}"

    response = StaplesResponse.new(post(url, request_body(code)))

    response.stock_available? ?
      notify_available!(manufacturer) { |link| "‼️ *STAPLES -> It's available locally!* link: #{link}\n" } :
      Alert.warn('Unavailable by API')
  end

  def request_body(code)
    {
      "locale": "en-CA",
      "postal_code": "L4B4M6",
      "items": [
        {
          "sku" => "2975995",
          "quantity" => 1000,
        },
      ],
      "location": "L4B 4M6",
    }
  end
end

StaplesPoller.new.poll
