require "bundler"
Bundler.require

Her::API.setup :base_uri => "http://localhost:4002", do |connection|
  connection.use Her::Middleware::AcceptJSON
  connection.use Faraday::Request::UrlEncoded
  connection.use Her::Middleware::DefaultParseJSON
  connection.use Faraday::Adapter::NetHttp
end

class User
  include Her::Model
end

Pry.start
