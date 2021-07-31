require './db/db_connector'

class ItemCategories
    attr_reader :id, :item_id, :category_id

    def initialize (id=nil, item_id, category_id)
        @id = id
        @item_id = item_id
        @category_id = category_id
    end

    def valid?
        return false if @category_id.nil?
        return false if @item_id.nil?
        return true
    end

    def save
        return false unless valid?
        client = create_db_client
        client.query("insert into item_categories (item_id, category_id) values (#{@item_id},#{@category_id});")
    end

    def update
        return false unless valid?
        client = create_db_client
        client.query("""
            update item_categories set 
                category_id = #{@category_id}
            where item_id = #{@item_id} and id = #{@id}
        """)
    end

    def delete
        return false unless valid?
        client = create_db_client
        client.query("""
                delete from item_categories
                where id = #{@id}
            """)
    end


    def self.get_item_categories(id=nil,item_id=nil)
        client = create_db_client

        condition_statement = nil
        if id != nil
            condition_statement = "id = #{id}"
        elsif item_id != nil
            condition_statement = "item_id = #{item_id}"
        end

        getItemCategoriesData=client.query("select * from item_categories where " + condition_statement)
        itemCat = nil
        getItemCategoriesData.each do |data|
            itemCat = ItemCategories.new(data["id"],data["category_id"],data["item_id"])
        end
        itemCat
    end

    def self.get_item_categories_by_category(category_id)
        client = create_db_client

        getItemCategoriesData=client.query("select * from item_categories where category_id = #{category_id}")
        itemCat = Array.new
        getItemCategoriesData.each do |data|
            itemCat.push(ItemCategories.new(data["id"],data["item_id"],data["category_id"]))
        end
        itemCat
    end







end