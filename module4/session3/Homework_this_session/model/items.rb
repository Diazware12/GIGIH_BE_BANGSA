require './db/db_connector'
require_relative 'categories'
require_relative 'item_categories'

class Item
    attr_reader :id, :name, :price, :category

    def initialize (id=nil, name, price, category)
        @id = id
        @name = name
        @price = price
        @category = category
    end

    def self.get_all_items
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

    def self.get_all_items_by_category(category_id,category_name)
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
                where c.id = #{category_id} and c.name = '#{category_name}'
            """)
        items = Array.new
        rawData.each do |data|
            category = Category.new(data["category_id"],data["category_name"])
            item = Item.new(data["item_id"],data["item_name"],data["item_price"],category)
            items.push(item)
        end
        items
    end

    def self.get_selected_item(product_id,product_name=nil)
        client = create_db_client

        additional_sentence = nil

        if product_name != nil
            additional_sentence = "and i.name like '%#{product_name}%'"
        else
            additional_sentence = ""
        end

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
                where i.id = #{product_id} "+additional_sentence+" limit 1
            """)
        items = nil
        rawData.each do |data|
            category = Category.new(data["category_id"],data["category_name"])
            items = Item.new(data["item_id"],data["item_name"],data["item_price"],category)
        end
        items
    end

    def save
        return false unless valid?
        client = create_db_client
        rawData=client.query("insert into items (name,price) values ('#{@name}',#{@price});")
        id = client.last_id
        saveItemCategory = ItemCategories.new(id, @category.id)
        saveItemCategory.save
    end

    def update
        return false unless valid?
        client = create_db_client
        client.query("""
                    update items set 
                        name = '#{@name}',
                        price = #{@price}
                    where id = #{@id}
            """)
        get_item_category = ItemCategories.get_item_categories(nil,@id)
        get_item_category.update     
    end

    def delete
        return false unless valid?
        client = create_db_client
        get_item_category = ItemCategories.get_item_categories(nil,@id)
        get_item_category.delete
        client.query("""
                delete from items
                where id = #{@id} and name = '#{@name}'
            """)
    end

    def valid?
        return false if @name.nil?
        return false if @price.nil?
        return false if @category.nil?
        return true
    end


end