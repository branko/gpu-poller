class SlackNotifier < BaseNotifier
  def message!(message)
    payload = {text: message}.to_s
    HTTParty.post(WEBHOOK_URL, body: payload)
  rescue
    puts "Something went wrong..."
  end

  private

  def build_message_from_queue
    return "\nNothing for now..." if @messages.empty?

    @messages.join
  end
end
