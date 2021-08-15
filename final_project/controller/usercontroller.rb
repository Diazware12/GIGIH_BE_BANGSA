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

    def editPage(params)
        getUser = User.getUserById(params['usId'])
        renderer = ERB.new(File.read("views/edituserdata.erb"))
        renderer.result(binding)        
    end

    def editData(params)
        getUser = User.getUserById(params['usId'])
        
        desc = nil
        if params['description'] == "" || params['description'] == nil
            desc = ""
        else
            desc = params['description']
        end

        editUser = User.new(
            userId: params['usId'],
            full_name: params['fullname'],
            username: params['username'],
            email: params['email'],
            description: desc
        )
        
        editUser.update
    end

    def editProfPicPage(params)
        getUser = User.getUserById(params['usId'])
        renderer = ERB.new(File.read("views/editprofilepicture.erb"))
        renderer.result(binding)        
    end

    def editProfPicData(params)
        
        filename = params[:profilePicture][:filename]
        file = params[:profilePicture][:tempfile]
      
        File.open("./public/transaction/#{filename}", 'wb') do |f|
          f.write(file.read)
        end

        getUser = User.getUserById(params['usId'])
        updatePicture = User.new(
            userId: getUser.userId,
            full_name: getUser.full_name,
            username: getUser.username,
            email: getUser.email,
            profile_pic: filename
        )
        updatePicture.updateProfilePic
        
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