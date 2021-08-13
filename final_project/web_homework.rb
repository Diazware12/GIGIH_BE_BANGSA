require 'sinatra' #gem install sinatra -> buat install
require_relative 'controller/usercontroller'
require_relative 'controller/tweetcontroller'
require './model/user'

userController = UserController.new
tweetController = TweetController.new

get '/' do
    userController.loginPage
end

post '/' do
    userController.loginUser(params)
end

get '/:usId/home' do
    userController.homepage(params)
end

get '/:usId/:tweetId/like' do
    tweetController.like(params)
    redirect "/#{params['usId']}/home"
end

get '/:usId/:tweetId/dislike' do
    tweetController.dislike(params)
    redirect "/#{params['usId']}/home"
end

get '/register' do
    erb:register
end

get '/forgotpassword' do
    erb:forgotPassword
end

get '/profile' do
    erb:profile
end

get '/explore' do
    erb:explore
end
