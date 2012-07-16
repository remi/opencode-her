require "logger"
require "bundler"
Bundler.require

# Her
# -------------------------------------------------------------
Her::API.setup :base_uri => "http://localhost:4002", do |c|
  # Request middleware
  c.use Her::Middleware::AcceptJSON
  c.use Faraday::Request::UrlEncoded

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
