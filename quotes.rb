require 'json'
require 'net/http'

class Quotes
  attr_reader :quote_set

  def initialize
    @quote_set = initiate_request
  end

  def random_quote
    @quote_set = @quote_set.sample
  end

  private

  def initiate_request
    JSON.parse(Net::HTTP.get(URI('https://type.fit/api/quotes')))
  end
end
