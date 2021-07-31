require './db/db_connector'

class Category
    attr_reader :id, :name

    def initialize(params)
        @id = params[:id]
        @name = params[:name]
    end

    def self.get_all_categories
        @client = create_db_client
        rawData = @client.query("SELECT * from categories")
        categories = Array.new
        rawData.each do |data|
            category = Category.new({"id":data['id'], "name":data['name']})
            categories.push(category)
        end
        categories
    end


    def self.get_categories(id)
        client = create_db_client
        result = client.query("select * from categories where id = #{id}")
        return nil unless result.count > 0
        data = result.first
        Category.new({"id":data['id'], "name":data['name']})
    end    

    def save
        return false unless valid?
        client = create_db_client
        client.query("insert into categories (name) values ('#{@name}')")
    end

    def update
        return false unless valid?
        client = create_db_client
        rawData=client.query("update categories set name = '#{@name}' where id = #{@id} ")
    end

    def delete
        return false unless valid?
        client = create_db_client
        client.query("delete from categories where id = #{@id} and name = '#{@name}'")
    end

    def valid?
        return false if @name.nil?
        return true
    end



end