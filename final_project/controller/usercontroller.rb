require './model/user'
require './model/tweet'
require './model/liketweet'
require './model/commenttweet'
require './model/follower'

class UserController

    def loginPage
        alert = nil
        renderer = ERB.new(File.read("views/login.erb"))
        renderer.result(binding)
    end

    def loginUser(params)
        getUser = User.getUser(params['username'],params['password'])
        if getUser == nil
            alert = "username didn't found or registered"
            renderer = ERB.new(File.read("views/login.erb"))
            renderer.result(binding)
        else
            tweetList = Tweet.tweetList(getUser.userId)
            renderer = ERB.new(File.read("views/index.erb"))
            renderer.result(binding)
        end
    end

    def homepage(params)
        tweetList = Tweet.tweetList(params['usId'])
        getUser = User.getUserById(params['usId'])

        renderer = ERB.new(File.read("views/index.erb"))
        renderer.result(binding)        
    end

    def comment(params)
        getTweet = Tweet.getTweet(params['tweetId'])
        commentList = CommentTweet.commentTweetListById(params['tweetId'])
        getUser = User.getUserById(params['usId'])

        renderer = ERB.new(File.read("views/comment.erb"))
        renderer.result(binding)        
    end

    def profile(params)
        getUser = User.getUserById(params['usId'])
        followers = Follower.followersListById(params['usId'])
        tweetList = Tweet.tweetListById(params['usId'])

        renderer = ERB.new(File.read("views/profile.erb"))
        renderer.result(binding)        
    end

    def otherProfile(params)

        return false if params['usId'] == params['otherUsId']

        getUser = User.getUserById(params['usId'])
        getOtherUser= User.getUserById(params['otherUsId'])

        followStatus = Follower.checkFollowStatus(params['usId'],params['otherUsId'])

        followers = Follower.followersListById(params['otherUsId'])
        tweetList = Tweet.otherTweetListById(params['otherUsId'],params['usId'])

        renderer = ERB.new(File.read("views/otherProfile.erb"))
        renderer.result(binding)        
    end

end