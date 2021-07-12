require 'sinatra' #gem install sinatra -> buat install

get '/' do
    "hello world"
end

get '/messages/:name' do
    name = params["name"]
    "hello world #{name}"
end


post '/insertItem' do
    prod = params['prod']
    type = params['type']
    "product #{prod} \n type #{type}"
end

get '/insertItem' do
    erb:insert
end