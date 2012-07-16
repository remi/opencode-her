require "logger"
require "bundler"
Bundler.require

Her::API.setup :base_uri => "http://localhost:4002", do |connection|
  # Request middleware
  connection.use Her::Middleware::AcceptJSON
  connection.use Faraday::Request::UrlEncoded

  # Response middleware
  connection.use Faraday::Response::Logger, Logger.new(STDOUT, :level => Logger::INFO).tap { |l| l.level = Logger::INFO }
  connection.use Her::Middleware::DefaultParseJSON

  # Adapters
  connection.use Faraday::Adapter::NetHttp
end

class User
  include Her::Model
  belongs_to :organization
end

class Organization
  include Her::Model
end

Pry.start
