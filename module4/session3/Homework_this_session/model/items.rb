require './db/db_connector'
require_relative 'categories'
require_relative 'item_categories'

class Item
    attr_reader :id, :name, :price, :category

    def initialize(params)
        @id = params[:id]
        @name = params[:name]
        @price = params[:price]
        @category = params[:category] ? params[:category] : nil
    end

    def self.get_all_items
        @client = create_db_client
        rawData = @client.query(
            "SELECT items.id as id, items.name as name, items.price as price, categories.name as category_name, categories.id as category_id FROM items JOIN item_categories JOIN categories WHERE items.id = item_categories.item_id and categories.id = item_categories.category_id"
        )
        items = []
        rawData.each do |data|
            category = Category.new({id:data["category_id"],name:data["category_name"]})
            item = Item.new({"id": data["id"], "name": data["name"], "price": data["price"], "category": category})
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
            category = Category.new({id:data["category_id"],name:data["category_name"]})
            item = Item.new({
                id: data["item_id"], 
                name: data["item_name"], 
                price: data["item_price"], 
                category: category
            })
            items.push(item)
        end
        items
    end

    def self.get_selected_item(product_id,product_name=nil)
        client = create_db_client
        result = client.query("select * from (select * from items where id = #{product_id}) item inner join item_categories on item_id = item.id")
        return nil unless result.count > 0
        data = result.first
        Item.new({"id": data['id'], "name": data['name'], "price": data['price'], "category": data['category_id']})
    end

    def save
        client = create_db_client
        client.query("INSERT INTO items (name, price) VALUES (#{@name}, #{@price})")
    end

    def update
        return false unless valid?
        client = create_db_client
        client.query("UPDATE item_categories SET category_id=#{@category.id} WHERE item_id = #{@id}")
        client.query("UPDATE items SET name=#{@name}, price=#{@price} WHERE id = #{@id}")
    end

    def delete
        client = create_db_client
        client.query("DELETE FROM items WHERE id = #{@id}")
    end

    def valid?
        return false if @name.nil?
        return false if @price.nil?
        return true
    end


end