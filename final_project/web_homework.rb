require 'sinatra' #gem install sinatra -> buat install
require_relative 'controller/usercontroller'
require_relative 'controller/tweetcontroller'
require_relative 'controller/commenttweetcontroller'
require './model/user'

userController = UserController.new
tweetController = TweetController.new
commenttweetcontroller = CommentTweetController.new

get '/' do
    userController.loginPage
end

post '/' do
    userController.loginUser(params)
end

get '/:usId/home' do
    userController.homepage(params)
end

post '/:usId/createTweet' do
    tweetController.createTweet(params)
    redirect "/#{params['usId']}/home"
end

get '/:usId/:tweetId/like' do
    tweetController.like(params)
    redirect "/#{params['usId']}/home"
end

get '/:usId/:tweetId/dislike' do
    tweetController.dislike(params)
    redirect "/#{params['usId']}/home"
end

get '/:usId/:tweetId/comment' do
    userController.comment(params)
end

post '/:usId/:tweetId/comment' do
    commenttweetcontroller.createCommentTweet(params)
    redirect "/#{params['usId']}/#{params['tweetId']}/comment"
end

get '/register' do
    erb:register
end

get '/forgotpassword' do
    erb:forgotPassword
end

get '/:usId/profile' do
    userController.profile(params)
end

get '/:usId/profile/:tweetId/like' do
    tweetController.like(params)
    redirect "/#{params['usId']}/profile"
end

get '/:usId/profile/:tweetId/dislike' do
    tweetController.dislike(params)
    redirect "/#{params['usId']}/profile"
end

post '/:usId/profile/createTweet' do
    tweetController.createTweet(params)
    redirect "/#{params['usId']}/profile"
end

get '/explore' do
    erb:explore
end
