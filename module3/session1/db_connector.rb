require 'mysql2'

def create_db_client
    client = Mysql::Client.new(
        :host => "localhost",
        :username => "sa",
        :password => "qwerty123",
        :database => "food_oms_db"
    )
    client
end

def get_all_item
    client = create_db_client
    client.query("select * from items")
end

puts (get_all_item.each)