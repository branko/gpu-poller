class SlackNotifier < BaseNotifier
  def message!(message)
    return unless message
    payload = JSON.generate({ text: message })
    res = HTTParty.post(WEBHOOK_URL, body: payload)
  end

  private

  def build_message_from_queue
    return nil if @messages.empty?

    output = @messages.join
    output += "\n<#{SLACK_USER_ID}>" if @notify_user

    output
  end
end
