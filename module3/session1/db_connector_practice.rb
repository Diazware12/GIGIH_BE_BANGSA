require 'mysql2'

def create_db_client
    client = Mysql2::Client.new(
        :host => "localhost",
        :username => "root",
        :password => "",
        :database => "food_oms_db"
    )
    client
end

def get_all_item
    client = create_db_client
    client.query("select * from items")
end

def get_all_categories
    client = create_db_client
    client.query("select * from categories")
end

def get_all_items_categories_price
    client = create_db_client
    client.query("""
            select 
                i.name as item_name,
                c.name as category_name,
                i.price as item_price
            from items as i 
            join item_categories as ic on i.id = ic.item_id
            join categories as c on c.id = ic.category_id
        """)
end

def get_all_items_categories_price_param(price)
    client = create_db_client
    client.query("""
            select 
                i.name as item_name,
                c.name as category_name,
                i.price as item_price
            from items as i 
            join item_categories as ic on i.id = ic.item_id
            join categories as c on c.id = ic.category_id
            where i.price <= #{price}
        """)
end

puts ("=================== 1 ===================")
puts (get_all_categories.each)
puts ("=================== 2 ===================")
puts (get_all_items_categories_price.each)
puts ("=================== 3 ===================")
print ("Choose Number price:")
number = gets.chomp.to_i
puts (get_all_items_categories_price_param(number).each)



