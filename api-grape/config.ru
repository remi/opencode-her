require "bundler"
Bundler.require

$db = Sequel.sqlite :database => "bluth.db"
$db.create_table? :users do
  primary_key :id
  String :username
  String :email
end

require "./app.rb"
run BluthCompany::API
