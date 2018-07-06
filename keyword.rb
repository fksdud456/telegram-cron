require 'telegram/bot'

token = ENV["telegram_token"]

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "가, #{message.from.first_name}")
    when '/manager'
      bot.api.send_message(chat_id: message.chat.id, text: "어, #{message.from.first_name}")
    when '/a'
      bot.api.send_message(chat_id: message.chat.id, text: "asdkfjsdklvjkcjkv!")
    when '/b'
      bot.api.send_message(chat_id: message.chat.id, text: "basdkfjsdklvjkcjkv!")
    end
  end
end