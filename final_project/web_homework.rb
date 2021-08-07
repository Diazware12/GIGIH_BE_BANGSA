require 'sinatra' #gem install sinatra -> buat install

get '/' do
    erb:index
end

get '/profile' do
    erb:profile
end

