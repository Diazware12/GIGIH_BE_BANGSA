require 'mysql2'
require_relative 'items'
require_relative 'category'

def create_db_client
    client = Mysql2::Client.new(
        :host => "localhost",
        :username => ENV["DB_USERNAME"],
        :password => ENV["DB_PASSWORD"],
        :database => ENV["DB_NAME"]
    )
    client
end