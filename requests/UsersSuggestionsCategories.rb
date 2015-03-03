require_relative '../core/TwitterRequest'

class UsersSuggestionsCategories < TwitterRequest

  def initialize(args)
    super args
  end

  def request_name
    "UsersSuggestionsCategories"
  end

  def twitter_endpoint
    "/users/suggestions"
  end

  def url
    'https://api.twitter.com/1.1/users/suggestions.json'
  end

  def success(response)
    log.info("SUCCESS")
    categories = JSON.parse(response.body)
    yield categories
  end
end
