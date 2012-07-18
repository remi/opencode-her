require "logger"
require "bundler"
Bundler.require

OAUTH_CREDENTIALS = {
  :consumer_key => "foo",
  :consumer_secret => "bar",
  :token => "lol",
  :token_secret => "omg"
}

$dalli = Dalli::Client.new("localhost:11211", :namespace => "her-demo")

# Her
# -------------------------------------------------------------
Her::API.setup :url => "http://localhost:4002", do |c|
  # Request middleware
  c.use Her::Middleware::AcceptJSON
  c.use Faraday::Request::UrlEncoded
  c.use FaradayMiddleware::OAuth, OAUTH_CREDENTIALS
  c.use FaradayMiddleware::Caching, $dalli

  # Response middleware
  c.use Faraday::Response::Logger, Logger.new(STDOUT, :level => Logger::INFO).tap { |l| l.level = Logger::INFO }
  c.use Her::Middleware::DefaultParseJSON

  # Adapters
  c.use Faraday::Adapter::NetHttp
end

# Models
# -------------------------------------------------------------
class User
  include Her::Model
  belongs_to :organization
end

class Organization
  include Her::Model
end

# Console
# -------------------------------------------------------------
Pry.start
