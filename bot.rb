
require 'telegram/bot'
require_relative 'lib/quotes.rb'
require_relative 'lib/jokes.rb'

token = ENV['BOT_TOKEN']

def send_menu(bot, chat_id)
  options = [
    ['/quote', 'To Quotes, type /quote'],
    ['/joke', 'To Quotes, type /joke'],
    ['/end', 'To end the bot type /end'],
    ['/menu', 'To Check the menu, type /menu']
  ]

  menu_text = "Please select an option:\n"
  options.each do |option|
    menu_text += "#{option[1]}\n"
  end

  bot.api.send_message(chat_id: chat_id, text: menu_text)
end

def get_quotes(bot, message)
  quote = Quotes.new.random_quote
  bot.api.send_message(chat_id: message.chat.id, text: "#{(quote['text']).to_s} - #{quote['author'].split(',')[0]}", date: message.date)
  bot.api.send_message(chat_id: message.chat.id, text: "Type /more_quote to get some more quotes")
end

def get_jokes(bot, message)
  joke = Jokes.new.joke_set
  bot.api.send_message(chat_id: message.chat.id, text: "#{joke['setup']}", date: message.date)
  sleep(5)
  bot.api.send_message(chat_id: message.chat.id, text: "Answer: \n #{joke['punchline']}")
  bot.api.send_message(chat_id: message.chat.id, text: "Type /more_joke to get some more jokes")
end

Telegram::Bot::Client.run(token, logger: Logger.new($stderr)) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Welcome to the Bot. Type /menu to get available options")
    when '/menu'
      send_menu(bot, message.chat.id)
    when '/quote'
      get_quotes(bot, message)
    when '/more_quote'
      get_quotes(bot, message)
    when '/joke'
      get_jokes(bot, message)
    when '/more_joke'
      get_jokes(bot, message)
    when '/end'
      bot.api.send_photo(chat_id: message.chat.id, photo: Faraday::UploadIO.new('lib/images/image1.jpeg', 'image/jpeg'))
      bot.api.send_photo(chat_id: message.chat.id, photo: 'https://c8.alamy.com/comp/R46J9P/bye-bye-comic-bubble-retro-text-R46J9P.jpg')
      bot.api.send_message(chat_id: message.chat.id, text: "Bye Bye, #{message.from.first_name}")
    else
      bot.api.send_message(chat_id: message.chat.id, text: "Invalid command. Type /menu to see the options.")
    end
  end
end
