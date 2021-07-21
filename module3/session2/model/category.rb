require '..db/db_connector'

class Category
    attr_reader :id, :name

    def initialize (id, name)
        @id = id
        @name = name
    end

    def get_all_categories
        client = create_db_client
        rawData=client.query("select * from categories")
        categories = Array.new
        rawData.each do |data|
            categories.push(Category.new(data["id"],data["name"]))
        end
        categories
    end

    def save
        return false unless valid?
        client = create_db_client
        rawData=client.query("insert into categories (name) values ('#{name}')")
    end

    def valid?
        return false if @name.nil?
        return true
    end

end