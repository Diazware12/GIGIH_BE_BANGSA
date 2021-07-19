require 'sinatra' #gem install sinatra -> buat install
require_relative 'db_connector'


get '/' do
    items = get_all_items_categories_price
    categories = get_all_categories
    puts(items.each)
    erb:index, locals:{
        items: items,
        categories: categories
    }
end

post '/create' do
    items = get_all_items_categories_price
    insert_items(params['item_name'],params['item_price'],params['item_category'])
    redirect '/'
end