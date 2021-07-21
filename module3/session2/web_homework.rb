require 'sinatra' #gem install sinatra -> buat install
require_relative 'db_connector'


get '/' do
    items = get_all_items_categories_price
    categories = get_all_categories
    erb:index, locals:{
        items: items,
        categories: categories
    }
end

post '/create' do
    insert_items(params['item_name'],params['item_price'],params['item_category'])
    redirect '/'
end

get '/update/:item_name' do
    item_name = params["item_name"]
    item_data = get_selected_item(item_name)
    categories = get_all_categories
    erb:update_item, locals:{
        item_data: item_data,
        categories: categories
    }
end

post '/update/submit' do
    update_items(params['item_name'],params['item_price'],params['item_id'],params['item_category'])
    redirect '/'
end

get '/delete/:item_id/:item_name' do
    delete(params['item_id'],params['item_name'])
    redirect '/'
end