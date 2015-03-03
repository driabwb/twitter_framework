require_relative '../core/TwitterRequest'

class UsersSuggestions < TwitterRequest

  def initialize(args)
    @slug = args[:params][:category]
    args[:params].delete(:category)
    puts @slug
    super args
  end

  def request_name
    "UsersSuggestions"
  end

  def twitter_endpoint
    "/users/suggestions"
  end

  def url
    'https://api.twitter.com/1.1/users/suggestions/' + @slug + '.json'
  end

  def success(response)
    log.info("SUCCESS")
    categories = JSON.parse(response.body)
    yield categories
  end
end
