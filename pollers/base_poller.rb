class BasePoller
  attr_reader :prefix, :notifier, :manufacturers, :errors

  def initialize
    @notifier = SlackNotifier.new
    @manufacturers = YAML.load(File.read("./pollers/data/#{prefix}_manufacturers.yml")).map do |m|
      @manufacturer_klass.new(*m)
    end

    @errors = []

    validate_manufacturers
  end
  
  def poll(&block)
    start!

    manufacturers.each(&-> (m) { process_code(m) })
    yield if block

    finish!
  end

  def start_scraping!
    notifier.message!("#{'-' * 40}\n⏱ #{time}: Beginning scraping! 🤞")
  end

  def start!
    # notifier.message!("#{'=' * 40}\n🚨 #{time}: Beginning polling!")
  end

  def finish!
    notifier.flush_and_send_queue!
    # notifier.message!("😴 Finished polling\n#{'=' * 40}")
  end

  def time
    Time.now.strftime("%I:%M %p")
  end

  def get(url)
    HTTParty.get(url)
  end

  def post(url, body)
    HTTParty.post(url, body: JSON.generate(body), headers: {
      'x-shop-token': '14d757296f4ac85eda09fd6117641b0e4cbe76d110576d881929d497d7acd7b2',
      'x-shop': 'staples-canada.myshopify.com',
      'authority': 'staples.boldapps.net',
      'content-type': 'application/json',
    })
  end

  def request_body
    raise NotImplementedError, 'Implement in subclass'
  end

  def notify_available!(manufacturer)
    slack_link = "<#{manufacturer.link_to_buy}|#{manufacturer.name}>"
    message = yield(slack_link)
    notifier.enqueue_messages!(message)
  end

  private
  
  def validate_manufacturers
    notifier.message!("⚠️⚠️⚠️ WARN: Something is wrong with #{self.class}: #{errors.join(', ')}") if invalid_manufacturers?
  end

  def invalid_manufacturers?
    if manufacturers.uniq { |m| m.code }.length < manufacturers.length
      @errors << "Duplicate manufacturer, check #{prefix}_manufacturers.yml"
    end
  end
end