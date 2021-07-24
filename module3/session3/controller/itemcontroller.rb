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
        getCat = Category.get_categories(params['item_category'])
        insert_item = Item.new(params['item_name'],params['item_price'],getCat)
        insert_item.save
    end

    def getItems(params)
        item_data = Item.get_selected_item(params["item_id"],params["item_name"])
        categories = Category.get_all_categories
        renderer = ERB.new(File.read("views/update_item.erb"))
        renderer.result(binding)
    end

    def editItems(params)
        getCat = Category.get_categories(params['item_category'])
        items = Item.new(params['item_id'],params['item_name'],params['item_price'],getCat)
        items.update
    end
    
    def deleteItems(params)
        item_data = Item.get_selected_item(params["item_id"],params["item_name"])
        item_data.delete
    end    

end