require 'json'
require 'net/http'

class Jokes
  attr_reader :joke_set

  def initialize
    @joke_set = initiate_request
  end

  private

  def initiate_request
    JSON.parse(Net::HTTP.get(URI('https://official-joke-api.appspot.com/jokes/random')))
  end
end
