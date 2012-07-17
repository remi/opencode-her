require "bundler"
Bundler.require

# Extend core classes
# -------------------------------------------------------------
require "./lib/hash_ext.rb"

# Database
# -------------------------------------------------------------
$db = Sequel.sqlite :database => "bluth.db"

$db.create_table? :users do
  primary_key :id
  String :username
  String :email
  Integer :organization_id
end

$db.create_table? :organizations do
  primary_key :id
  String :name
end

# RABL
# -------------------------------------------------------------
Rabl.configure do |config|
  config.include_json_root = false
  config.include_child_root = false
end

# Models
# -------------------------------------------------------------
class User < Sequel::Model; end
class Organization < Sequel::Model; end

# Rack app
# -------------------------------------------------------------
require "./app.rb"
run BluthCompany::API
