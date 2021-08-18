require 'sinatra' #gem install sinatra -> buat install
require 'json'
require_relative 'controller/usercontroller'
require_relative 'controller/tweetcontroller'
require_relative 'controller/commenttweetcontroller'
require_relative 'controller/explorecontroller'
require_relative 'controller/followerController'
require_relative 'controller/trendingcontroller'
require_relative 'controller/findpeoplecontroller'
require './model/user'


set :prefix, '/api/v1'

userController = UserController.new
tweetController = TweetController.new
exploreController = ExploreController.new
commenttweetcontroller = CommentTweetController.new
followerController = FollowerController.new
trendingController = TrendingController.new
findPeopleController = FindPeopleController.new

#web application url
    get '/' do
        userController.loginPage
    end

    post '/' do
        userController.loginUser(params)
    end

    get '/:userId/home' do
        userController.homepage(params)
    end


    post '/:userId/createTweet' do
        tweetController.createTweet(params)
        redirect "/#{params['userId']}/home"
    end


    get '/:userId/:tweetId/like' do
        tweetController.like(params)
        redirect "/#{params['userId']}/home"
    end

    get '/:userId/:tweetId/dislike' do
        tweetController.dislike(params)
        redirect "/#{params['userId']}/home"
    end

    get '/:userId/:tweetId/comment' do
        userController.commentPage(params)
    end

    post '/:userId/:tweetId/comment' do
        commenttweetcontroller.createCommentTweet(params)
        redirect "/#{params['userId']}/#{params['tweetId']}/comment"
    end

    get '/:userId/:tweetId/delete' do
        tweetController.deleteTweet(params)
        redirect "/#{params['userId']}/home"
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

        get '/:userId/profile' do
            userController.profile(params)
        end

        get '/:userId/profile/editdata' do
            userController.editPage(params)
        end

        post '/:userId/profile/editdata' do
            userController.editData(params)
            redirect "/#{params["userId"]}/profile"
        end

        get '/:userId/profile/editprofpic' do
            userController.editProfPicPage(params)
        end

        post '/:userId/profile/editprofpic' do
            userController.editProfPicData(params)
            redirect "/#{params["userId"]}/profile"
        end

        get '/:userId/profile/:tweetId/like' do
            tweetController.like(params)
            redirect "/#{params['userId']}/profile"
        end

        get '/:userId/profile/:tweetId/dislike' do
            tweetController.dislike(params)
            redirect "/#{params['userId']}/profile"
        end

        get '/:userId/profile/:tweetId/delete' do
            tweetController.deleteTweet(params)
            redirect "/#{params['userId']}/profile"
        end

        post '/:userId/profile/createTweet' do
            tweetController.createTweet(params)
            redirect "/#{params['userId']}/profile"
        end

    # other profile

        get '/:userId/:otherUsId/profile' do
            userController.otherProfile(params)
        end

        get '/:userId/:userFollowersId/profile/follow' do
            followerController.follow(params)
            redirect "/#{params["userId"]}/#{params["userFollowersId"]}/profile"
        end

        get '/:userId/:userFollowersId/profile/unfollow' do
            followerController.unfollow(params)
            redirect "/#{params["userId"]}/#{params["userFollowersId"]}/profile"
        end

        get '/:userId/:otherUsId/profile/:tweetId/like' do
            tweetController.like(params)
            redirect "/#{params["userId"]}/#{params["otherUsId"]}/profile"
        end

        get '/:userId/:otherUsId/profile/:tweetId/dislike' do
            tweetController.dislike(params)
            redirect "/#{params["userId"]}/#{params["otherUsId"]}/profile"
        end

    get '/:userId/explore/:hashtagId/details' do
        exploreController.details(params)
    end

    get '/:userId/explore/:hashtagId/details/:tweetId/like' do
        tweetController.like(params)
        redirect "/#{params['userId']}/explore/#{params['hashtagId']}/details"
    end

    get '/:userId/explore/:hashtagId/details/:tweetId/dislike' do
        tweetController.dislike(params)
        redirect "/#{params['userId']}/explore/#{params['hashtagId']}/details"
    end

    get '/:userId/trending' do
        trendingController.trendingPage(params)
    end

    get '/:userId/findpeople' do
        findPeopleController.findPeople(params)
    end




#API Test

    post "#{settings.prefix}/register" do
        response = userController.register_API(params)

        return response.to_json
    end

    post "#{settings.prefix}/forgotpassword" do
        response = userController.forgotPassword_API(params)

        return response.to_json
    end

    post "#{settings.prefix}/login" do
        response = userController.login_API(params)

        return response.to_json
    end

    post "#{settings.prefix}/createnewtweet" do
        response = tweetController.createTweet_API(params)

        return response.to_json
    end

        post "#{settings.prefix}/liketweet" do
            response = tweetController.like_API(params)

            return response.to_json
        end

        post "#{settings.prefix}/disliketweet" do
            response = tweetController.dislike_API(params)

            return response.to_json
        end

        post "#{settings.prefix}/deletetweet" do
            response = tweetController.deleteTweet_API(params)

            return response.to_json
        end

    get "#{settings.prefix}/commenttweet" do
        response = userController.commentPage_API(params)

        return response.to_json
    end

    post "#{settings.prefix}/commenttweet" do
        response = commenttweetcontroller.createCommentTweet_API(params)

        return response.to_json
    end

    get "#{settings.prefix}/profilepage" do
        response = userController.profile_API(params)

        return response.to_json
    end

    post "#{settings.prefix}/editprofiledata" do
        response = userController.editData_API(params)

        return response.to_json
    end

    post "#{settings.prefix}/editprofilepicture" do
        response = userController.editProfPicData_API(params)

        return response.to_json
    end

    get "#{settings.prefix}/otherprofilepage" do
        response = userController.otherProfile_API(params)

        return response.to_json
    end

    