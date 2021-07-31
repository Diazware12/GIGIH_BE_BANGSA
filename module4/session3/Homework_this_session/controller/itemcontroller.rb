require './model/items'
require './model/categories'

class ItemController
    def listItems
        items = Item.get_all_items
        categories = Category.get_all_categories
        renderer = ERB.new(File.read("views/index.erb"))
        renderer.result(binding)
    end

    def createItems(params)
        item = Item.new(params)
        return false unless item.valid?
        item.save
    end

    def show
        renderer = ERB.new(File.read("views/show.erb"))
        renderer.result(binding)
    end

    def getItems(params)
        item_data = Item.get_selected_item(params["item_id"],params["item_name"])
        categories = Category.get_all_categories
        renderer = ERB.new(File.read("views/update_item.erb"))
        renderer.result(binding)
    end

    def editItems(params)
        item = Item.get_selected_item(params['id'])
        return false unless item
    
        item.name = params['name']
        item.price = params['price']
        item.category = params['category']
        item.update
    
        true
    end
    
    def deleteItems(params)
        item = Item.get_selected_item(params['id'])
        return false unless item
    
        item.delete
    end    

end