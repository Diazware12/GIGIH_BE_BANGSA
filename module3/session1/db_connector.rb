require 'mysql2'
require_relative 'items'
require_relative 'category'

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
    rawData = client.query("select * from items")
    items = Array.new
    rawData.each do |data|
        item = Item.new(data["id"],data["name"],data["price"])
        items.push(item)
    end
    items
end

def get_all_categories
    client = create_db_client
    rawData=client.query("select * from categories")
    categories = Array.new
    rawData.each do |data|
        category = Category.new(data["id"],data["name"])
        categories.push(category)
    end
    categories
end

def insert_items(name,price,category_id)
    client = create_db_client
    client.query("insert into items (name, price) values ('#{name}',#{price});")
    id = client.last_id
    client.query("insert into item_categories (item_id, category_id) values (#{id},#{category_id});")
end


def get_all_items_categories_price
    client = create_db_client
    rawData=client.query("""
            select 
                i.id as item_id,
                i.name as item_name,
                i.price as item_price,
                c.id as category_id,
                c.name as category_name
            from items as i 
            join item_categories as ic on i.id = ic.item_id
            join categories as c on c.id = ic.category_id
        """)
    items = Array.new
    rawData.each do |data|
        category = Category.new(data["category_id"],data["category_name"])
        item = Item.new(data["item_id"],data["item_name"],data["item_price"],category)
        items.push(item)
    end
    items
end


def get_selected_item(product_name)
    client = create_db_client
    rawData=client.query("""
            select 
                i.id as item_id,
                i.name as item_name,
                i.price as item_price,
                c.id as category_id,
                c.name as category_name
            from items as i 
            join item_categories as ic on i.id = ic.item_id
            join categories as c on c.id = ic.category_id
            where i.name like '%#{product_name}%' limit 1
        """)
    items = Array.new
    rawData.each do |data|
        category = Category.new(data["category_id"],data["category_name"])
        item = Item.new(data["item_id"],data["item_name"],data["item_price"],category)
        items.push(item)
    end
    items
end

def update_items(name,price,item_id,category_id)
    client = create_db_client
    client.query("""
                update items set 
                    name = '#{name}'
                where id = #{item_id}
        """)
        
    client.query("""
            update item_categories set 
                category_id = #{category_id}
            where item_id = #{item_id}
        """)
end

def delete(id,name)
    client = create_db_client
    client.query("""
            delete from item_categories
            where item_id = #{id}
        """)
        
    client.query("""
            delete from items
            where id = #{id} and name = '#{name}'
        """)
end