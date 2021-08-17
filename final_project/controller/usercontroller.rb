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

    def registerPage(params,context)
        if context == "page"
            alert = nil
            renderer = ERB.new(File.read("views/register.erb"))
            renderer.result(binding)
        else
            alert = nil
            getUser = User.new(
                full_name: params["full_name"],
                username: params["username"],
                email: params["email"],
                password: params["password"],
                gender: params["gender"]
            )

            exist = User.checkUser(getUser.username)

            if params["password"] != params["conpass"]
                alert = "Confirm password should be same as password"
            elsif params["username"].include? " "
                alert = "username cannot contain space (' ')"
            elsif exist == true
                alert = "username already used by other user"
            end

            if alert != nil
                renderer = ERB.new(File.read("views/register.erb"))
                renderer.result(binding)
            else 
                getUser.save
                renderer = ERB.new(File.read("views/login.erb"))
                renderer.result(binding)
            end
            
        end
    end

    def forgotPassword(params,context)
        if context == "page"
            alert = nil
            renderer = ERB.new(File.read("views/forgotPassword.erb"))
            renderer.result(binding)
        else
            alert = nil

            exist = User.checkUser(params["username"])

            if params["password"] != params["conpass"]
                alert = "Confirm password should be same as password"
            elsif params["username"].include? " "
                alert = "username cannot contain space (' ')"
            elsif exist == false
                alert = "username not found"
            end

            if alert != nil
                renderer = ERB.new(File.read("views/register.erb"))
                renderer.result(binding)
            else 
                getUser = User.getUserByName(params["username"])

                updatePass = User.new(
                    userId: getUser.userId,
                    full_name: getUser.full_name,
                    username: getUser.username,
                    email: getUser.email,
                    password: params["password"]
                )
                updatePass.updatePassword

                renderer = ERB.new(File.read("views/login.erb"))
                renderer.result(binding)
            end
            
        end
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
        tweetList = Tweet.tweetList(params['userId'])
        getUser = User.getUserById(params['userId'])

        renderer = ERB.new(File.read("views/index.erb"))
        renderer.result(binding)        
    end

    def comment(params)
        getTweet = Tweet.getTweet(params['tweetId'])
        commentList = CommentTweet.commentTweetListById(params['tweetId'])
        getUser = User.getUserById(params['userId'])

        renderer = ERB.new(File.read("views/comment.erb"))
        renderer.result(binding)        
    end

    def profile(params)
        getUser = User.getUserById(params['userId'])
        followers = Follower.followersListById(params['userId'])
        tweetList = Tweet.tweetListById(params['userId'])

        renderer = ERB.new(File.read("views/profile.erb"))
        renderer.result(binding)        
    end

    def editPage(params)
        getUser = User.getUserById(params['userId'])
        renderer = ERB.new(File.read("views/edituserdata.erb"))
        renderer.result(binding)        
    end

    def editData(params)
        getUser = User.getUserById(params['userId'])
        
        desc = nil
        if params['description'] == "" || params['description'] == nil
            desc = ""
        else
            desc = params['description']
        end

        editUser = User.new(
            userId: params['userId'],
            full_name: params['fullname'],
            username: params['username'],
            email: params['email'],
            description: desc
        )
        
        editUser.update
    end

    def editProfPicPage(params)
        getUser = User.getUserById(params['userId'])
        renderer = ERB.new(File.read("views/editprofilepicture.erb"))
        renderer.result(binding)        
    end

    def editProfPicData(params)
        
        filename = params[:profilePicture][:filename]
        file = params[:profilePicture][:tempfile]
      
        File.open("./public/transaction/#{filename}", 'wb') do |f|
          f.write(file.read)
        end

        getUser = User.getUserById(params['userId'])
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

        return false if params['userId'] == params['otherUsId']

        getUser = User.getUserById(params['userId'])
        getOtherUser= User.getUserById(params['otherUsId'])

        followStatus = Follower.checkFollowStatus(params['userId'],params['otherUsId'])

        followers = Follower.followersListById(params['otherUsId'])
        tweetList = Tweet.otherTweetListById(params['otherUsId'],params['userId'])

        renderer = ERB.new(File.read("views/otherProfile.erb"))
        renderer.result(binding)        
    end

end