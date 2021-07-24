require './db/db_connector'

class Category
    attr_reader :id, :name

    def initialize (id=nil, name)
        @id = id
        @name = name
    end

    def self.get_all_categories
        client = create_db_client
        rawData=client.query("select * from categories")
        categories = Array.new
        rawData.each do |data|
            categories.push(Category.new(data["id"],data["name"]))
        end
        categories
    end


    def self.get_categories(id)
        client = create_db_client
        rawData=client.query("select * from categories where id = #{id}")
        categories = nil
        rawData.each do |data|
            categories=Category.new(data["id"],data["name"])
        end
        categories
    end    

    def save
        return false unless valid?
        client = create_db_client
        rawData=client.query("insert into categories (name) values ('#{@name}')")
    end

    def update
        return false unless valid?
        client = create_db_client
        rawData=client.query("update categories set name = '#{@name}' where id = #{@id} ")
    end

    def delete
        return false unless valid?
        client = create_db_client
        client.query("""
                delete from categories
                where id = #{@id} and name = '#{@name}'
            """)
    end

    def valid?
        return false if @name.nil?
        return true
    end



end