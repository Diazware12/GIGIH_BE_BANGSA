require '..db/db_connector'
require '..model/category'

class Item
    attr_reader :id, :name, :price, :category

    def initialize (id, name, price, category)
        @id = id
        @name = name
        @price = price
        @category = category
    end


    def get_all_items_data
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

    def save
        return false unless valid?
        client = create_db_client
        rawData=client.query("insert into items (name,price) values ('#{name}',#{price});")
        id = client.last_id
        # client.query("insert into item_categories (item_id, category_id) values (#{id},#{category_id});")
    end

    def valid?
        return false if @name.nil?
        return false if @price.nil?
        return false if @category.nil?
        return true
    end

    def update(name,price,item_id,category_id)

        return false unless valid?
        client = create_db_client
        client.query("""
                    update items set 
                        name = '#{name}',
                        price = #{price}
                    where id = #{item_id}
            """)
            
        client.query("""
                update item_categories set 
                    category_id = #{category_id}
                where item_id = #{item_id}
            """)
    end

    def delete(id,name)
        return false unless valid?
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


end