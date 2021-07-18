require 'sinatra' #gem install sinatra -> buat install

get '/' do
    "hello world"
end

get '/messages/:name' do
    name = params["name"]
    "hello world #{name}"
end

items = {name: [], type: []}

post '/insertItem' do
    items[:name] << params['prod']
    items[:type] << params['type']
    "#{items}"
end

get '/insertItem' do
    erb:insert
end