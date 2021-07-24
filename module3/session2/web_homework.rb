require 'sinatra' #gem install sinatra -> buat install
require_relative 'model/items'
require_relative 'model/category'

get '/' do
    items = Item.get_all_items
    categories = Category.get_all_categories
    erb:index, locals:{
        items: items,
        categories: categories
    }
end

post '/create' do
    getCat = Category.get_categories(params['item_category'])
    insert_item = Item.new(params['item_name'],params['item_price'],getCat)
    insert_item.save
    redirect '/'
end

get '/update/:item_id/:item_name' do
    item_data = Item.get_selected_item(params["item_id"],params["item_name"])
    categories = Category.get_all_categories
    erb:update_item, locals:{
        item: item_data,
        categories: categories
    }
end

post '/update/submit' do
    getCat = Category.get_categories_for_class(params['item_category'])
    items = Item.new(params['item_id'],params['item_name'],params['item_price'],getCat)
    items.update
    redirect '/'
end

get '/delete/:item_id/:item_name' do
    item_data = Item.get_selected_item(params["item_id"],params["item_name"])
    item_data.delete
    redirect '/'
end