class AiResponseJob < ApplicationJob
  queue_as :default

  def perform(chat_message_id)
    chat_message = ChatMessage.find(chat_message_id)
    client = Ollama.new(
      credentials: { address: 'http://localhost:11434' },
      options: { server_sent_events: true }
    )

    result = client.generate(
      { model: 'llama2',
        prompt: chat_message.body }
    )

    text = result.map { |r| r["response"] }.join
    chat_message.broadcast_prepend_to(:ai_messages, target: "ai-messages", partial: "chat_messages/ai_response", locals: { text: text})
  end
end
