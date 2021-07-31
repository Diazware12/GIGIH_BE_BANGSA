require './model/items'
require './model/categories'

class CategoryController
    def listCategory
        categories = Category.get_all_categories
        renderer = ERB.new(File.read("views/show_categories.erb"))
        renderer.result(binding)
    end

    def show
        renderer = ERB.new(File.read("views/show.erb"))
        renderer.result(binding)
    end

    def createCategory(params)
        category = Category.new(params['category_name'])
        category.save
    end

    def showDetails(params)
        category_data = Category.get_categories(params["id"])
        item_list = Item.get_all_items_by_category(category_data.id,category_data.name)
        renderer = ERB.new(File.read("views/show_category_details.erb"))
        renderer.result(binding)
    end

    def getCategory(params)
        category_data = Category.get_categories(params["id"])
        renderer = ERB.new(File.read("views/update_category.erb"))
        renderer.result(binding)
    end

    def editCategory(params)
        category = Category.get_categories(params['id'])
        return false unless category
        category.name = params['name']
        category.update
    
        true
    end

    def deleteCategory(params)
        category = Category.get_categories(params['id'])
        return false unless category
        category.delete

    end

end