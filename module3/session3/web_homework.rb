require 'sinatra' #gem install sinatra -> buat install
require_relative 'controller/itemcontroller'
require_relative 'controller/categorycontroller'

item_controller = ItemController.new
category_controller = CategoryController.new

get '/' do
    item_controller.listItems
end

post '/create' do
    item_controller.createItems(params)
    redirect '/'
end

get '/update/:item_id/:item_name' do
    item_controller.getItems(params)
end

post '/update/submit' do
    item_controller.editItems(params)
    redirect '/'
end

get '/delete/:item_id/:item_name' do
    item_controller.deleteItems(params)
    redirect '/'
end



get '/showCategoryList' do
    category_controller.listCategory
end

post '/showCategoryList/create' do
    category_controller.createCategory(params)
    redirect '/showCategoryList'
end

get '/showCategoryList/details/:id/:category_name' do
    category_controller.showDetails(params)
end

get '/showCategoryList/update/:id/:category_name' do
    category_controller.getCategory(params)
end

post '/showCategoryList/update/submit' do
    category_controller.editCategory(params)
    redirect '/showCategoryList'
end

get '/showCategoryList/delete/:category_id/:category_name' do
    category_controller.deleteCategory(params)
    redirect '/showCategoryList'
end
