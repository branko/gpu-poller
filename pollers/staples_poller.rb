load 'setup.rb'

class StaplesResponse

end

class StaplesPoller < BasePoller
  def initialize
    @manufacturer_klass = StaplesManufacturer
    @prefix = 'staples'
    super
  end

  private
  
  def process_code(manufacturer)
    code = manufacturer.code
    url = manufacturer.url
    # Alert.info "Fetching #{manufacturer.name}"

    response = StaplesResponse.new(post(url, request_body(code)))

    if response.stock_available?
      response.log_available!(notifier)
      notifier.notify_user!

      notify_available!(manufacturer) { |link| "‼️ *STAPLES =>* link: #{link}\n" }
    end
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
