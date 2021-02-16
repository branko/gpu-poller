class SlackNotifier < BaseNotifier
  def message!(message)
    payload = JSON.generate({ text: message })
    res = HTTParty.post(WEBHOOK_URL, body: payload)
    puts res
  end

  private

  def build_message_from_queue
    return "\nNothing for now..." if @messages.empty?

    @messages.join
  end
end
