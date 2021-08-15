require 'sinatra' #gem install sinatra -> buat install
require_relative 'controller/usercontroller'
require_relative 'controller/tweetcontroller'
require_relative 'controller/commenttweetcontroller'
require_relative 'controller/explorecontroller'
require_relative 'controller/followerController'
require_relative 'controller/trendingcontroller'
require_relative 'controller/findpeoplecontroller'
require './model/user'

userController = UserController.new
tweetController = TweetController.new
exploreController = ExploreController.new
commenttweetcontroller = CommentTweetController.new
followerController = FollowerController.new
trendingController = TrendingController.new
findPeopleController = FindPeopleController.new

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

get '/:usId/:tweetId/delete' do
    tweetController.deleteTweet(params)
    redirect "/#{params['usId']}/home"
end

get '/register' do
    userController.registerPage(params,"page")
end

post '/register' do
    userController.registerPage(params,"submit")
end

get '/forgotpassword' do
    userController.forgotPassword(params,"page")
end

post '/forgotpassword' do
    userController.forgotPassword(params,"submit")
end

# own profile

    get '/:usId/profile' do
        userController.profile(params)
    end

    get '/:usId/profile/editdata' do
        userController.editPage(params)
    end

    post '/:usId/profile/editdata' do
        userController.editData(params)
        redirect "/#{params["usId"]}/profile"
    end

    get '/:usId/profile/editprofpic' do
        userController.editProfPicPage(params)
    end

    post '/:usId/profile/editprofpic' do
        userController.editProfPicData(params)
        redirect "/#{params["usId"]}/profile"
    end

    get '/:usId/profile/:tweetId/like' do
        tweetController.like(params)
        redirect "/#{params['usId']}/profile"
    end

    get '/:usId/profile/:tweetId/dislike' do
        tweetController.dislike(params)
        redirect "/#{params['usId']}/profile"
    end

    get '/:usId/profile/:tweetId/delete' do
        tweetController.deleteTweet(params)
        redirect "/#{params['usId']}/profile"
    end

    post '/:usId/profile/createTweet' do
        tweetController.createTweet(params)
        redirect "/#{params['usId']}/profile"
    end

# other profile

    get '/:usId/:otherUsId/profile' do
        userController.otherProfile(params)
    end

    get '/:usId/:otherUsId/profile/follow' do
        followerController.follow(params)
        redirect "/#{params["usId"]}/#{params["otherUsId"]}/profile"
    end

    get '/:usId/:otherUsId/profile/unfollow' do
        followerController.unfollow(params)
        redirect "/#{params["usId"]}/#{params["otherUsId"]}/profile"
    end

    get '/:usId/:otherUsId/profile/:tweetId/like' do
        tweetController.like(params)
        redirect "/#{params["usId"]}/#{params["otherUsId"]}/profile"
    end

    get '/:usId/:otherUsId/profile/:tweetId/dislike' do
        tweetController.dislike(params)
        redirect "/#{params["usId"]}/#{params["otherUsId"]}/profile"
    end




get '/:usId/explore' do
    exploreController.explorePage(params)
end

get '/:usId/explore/:hashtagId/details' do
    exploreController.details(params)
end

get '/:usId/explore/:hashtagId/details/:tweetId/like' do
    tweetController.like(params)
    redirect "/#{params['usId']}/explore/#{params['hashtagId']}/details"
end

get '/:usId/explore/:hashtagId/details/:tweetId/dislike' do
    tweetController.dislike(params)
    redirect "/#{params['usId']}/explore/#{params['hashtagId']}/details"
end

get '/:usId/trending' do
    trendingController.trendingPage(params)
end

get '/:usId/findpeople' do
    findPeopleController.findPeople(params)
end
