require "bundler"
Bundler.require

OAUTH_CREDENTIALS = {
  :consumer_key => "foo",
  :consumer_secret => "bar",
  :token => "lol",
  :token_secret => "omg"
}

Her::API.setup :base_uri => "http://localhost:4002", do |connection|
  connection.use Her::Middleware::AcceptJSON
  connection.use FaradayMiddleware::OAuth, OAUTH_CREDENTIALS
  connection.use Faraday::Request::UrlEncoded
  connection.use Her::Middleware::DefaultParseJSON
  connection.use Faraday::Adapter::NetHttp
end

class User
  include Her::Model
end

Pry.start
