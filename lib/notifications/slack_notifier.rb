class SlackNotifier < BaseNotifier
  def message!(message)
    payload = JSON.generate({ text: message })
    res = HTTParty.post(WEBHOOK_URL, body: payload)
  end

  private

  def build_message_from_queue
    return "Nothing for now..." if @messages.empty?

    @messages.join + "\n<#{SLACK_USER_ID}>"
  end
end
