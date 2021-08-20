require './model/user'
require './model/tweet'
require './model/liketweet'
require './model/commenttweet'
require './model/follower'
require_relative 'generalcontroller'

class UserController

    #web application purposes
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

    def commentPage(params)
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
        alert = nil
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

        alert = nil
        exist = User.checkUser(params['username'])
        if params["username"].include? " "
            alert = "username cannot contain space (' ')"
        elsif exist == true && getUser.username != params['username']
            alert = "username already used by other user"
        end

        if alert == nil
            editUser = User.new(
                userId: params['userId'],
                full_name: params['fullname'],
                username: params['username'],
                email: params['email'],
                description: desc
            )
            
            editUser.update
        end

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


    #API Purposes
    def register_API(params)

        alert = nil

        exist = User.checkUser(params["username"])

        if params["password"] != params["conpass"]
            alert = "Confirm password should be same as password"
        elsif params["username"].include? " "
            alert = "username cannot contain space (' ')"
        elsif !(params['email'].match(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i))
            alert = "wrong email format"
        elsif exist == true
            alert = "username already used by other user"
        end

        if alert != nil
            return {
                'message' => alert,
                'status' => 401,
                'method' => 'POST',
                'data' => params
            }
        else 
            getUser = User.new(
                full_name: params["full_name"],
                username: params["username"],
                email: params["email"],
                password: params["password"],
                gender: params["gender"]
            )
            getUser.save
            response = User.getUser(params["username"],params["password"])
            return {
                'message' => 'Success',
                'status' => 200,
                'method' => 'POST',
                'data' => {
                    "full_name": response.full_name,
                    "username": response.username,
                    "email": response.email,
                    "password": response.password,
                    "gender": response.gender
                }
            }
        end
            

    end

    def forgotPassword_API(params)

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
            return {
                'message' => alert,
                'status' => 401,
                'method' => 'POST',
                'data' => params
            }
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

            return {
                'message' => 'Success',
                'status' => 200,
                'method' => 'POST',
                'data' => {
                    "userId": updatePass.userId,
                    "full_name": updatePass.full_name,
                    "username": updatePass.username,
                    "email": updatePass.email,
                    "password": updatePass.password
                }
            }
        end
            

    end

    def login_API(params)
        getUser = User.getUser(params['username'],params['password'])
        if GeneralController.checkNil(getUser) == true
            alert = "username didn't found or registered"
            return {
                'message' => alert,
                'status' => 401,
                'method' => 'POST',
                'data' => params
            }
        else
            tweets = Tweet.tweetList(getUser.userId)

            tweetsResponse = []

            tweets.each do |tweet|
                tweetsResponse.push({
                    "tweetId": tweet.tweetId,
                    "userId": [{
                        "userId": tweet.userId.userId,
                        "username": tweet.userId.username,
                        "full_name": tweet.userId.full_name
                    }],
                    "content": tweet.content,
                    "attachment": tweet.attachment,
                    "dtm_crt": tweet.dtm_crt,
                    "likes": tweet.likes,
                    "alreadyLike": tweet.alreadyLike,
                    "comments": tweet.comments,
                    "hashtags": tweet.hashtags
                })
            end

            return {
                'message' => 'Success',
                'status' => 200,
                'method' => 'POST',
                'data' => {
                    "Current Log-In User" => {
                        "full_name": getUser.full_name,
                        "username": getUser.username,
                        "email": getUser.email,
                        "password": getUser.password,
                        "gender": getUser.gender
                    },
                    'tweetList' => tweetsResponse
                }
            }
        end
    end

    def commentPage_API(params)
        getTweet = Tweet.getTweet(params['tweetId'])
        comments = CommentTweet.commentTweetListById(params['tweetId'])
        getUser = User.getUserById(params['userId'])


        return {
            'message' => 'user not found',
            'status' => 401,
            'method' => 'POST',
            'data' => params
        } if GeneralController.checkNil(getUser) == true
        return {
            'message' => 'tweet not found',
            'status' => 401,
            'method' => 'POST',
            'data' => params
        } if GeneralController.checkNil(getTweet) == true

        commentResponse = []

        comments.each do |comments|
            commentResponse.push({
                "commentTweetId": comments.commentTweetId,
                "userId": [{
                    "userId": comments.userId.userId,
                    "username": comments.userId.username,
                    "full_name": comments.userId.full_name
                }],
                "tweetId": comments.tweetId,
                "comment_tweet": comments.comment_tweet,
                "hashtags": comments.hashtags,
                "dtm_crt": comments.dtm_crt,
                "attachment": comments.attachment
            })
        end

        return {
            'message' => 'Success',
            'status' => 200,
            'method' => 'GET',
            'data' => {
                'current log-in user' => {
                    "full_name": getUser.full_name,
                    "username": getUser.username,
                    "email": getUser.email,
                    "password": getUser.password,
                    "gender": getUser.gender
                },
                'tweet-comment data' => {
                    "tweet-data": {
                        "tweetId": getTweet.tweetId,
                        "userId": [{
                            "userId": getTweet.userId.userId,
                            "username": getTweet.userId.username,
                            "full_name": getTweet.userId.full_name
                        }],
                        "content": getTweet.content,
                        "attachment": getTweet.attachment,
                        "dtm_crt": getTweet.dtm_crt,
                        "likes": getTweet.likes,
                        "alreadyLike": getTweet.alreadyLike,
                        "comments": getTweet.comments,
                        "hashtags": getTweet.hashtags
                    },
                    "comment-data": commentResponse
                }
            }            
        }
    end

    def profile_API(params)
        getUser = User.getUserById(params['userId'])
        followers = Follower.followersListById(params['userId'])
        tweets = Tweet.tweetListById(params['userId'])

        return {
            'message' => 'user not found',
            'status' => 401,
            'method' => 'POST',
            'data' => params
        } if GeneralController.checkNil(getUser) == true

        tweetsResponse = []
        followerResponse = []

        tweets.each do |tweet|
            tweetsResponse.push({
                "tweetId": tweet.tweetId,
                "userId": [{
                    "userId": tweet.userId.userId,
                    "username": tweet.userId.username,
                    "full_name": tweet.userId.full_name
                }],
                "content": tweet.content,
                "attachment": tweet.attachment,
                "dtm_crt": tweet.dtm_crt,
                "likes": tweet.likes,
                "alreadyLike": tweet.alreadyLike,
                "comments": tweet.comments,
                "hashtags": tweet.hashtags
            })
        end

        followers.each do |follower|
            followerResponse.push({
                "followersId": follower.followersId,
                "userFollowersId": [{
                    "userId": follower.userFollowersId.userId,
                    "username": follower.userFollowersId.username,
                    "full_name": follower.userFollowersId.full_name
                }],
                "dtm_crt": follower.dtm_crt
            })
        end

        return {
            'message' => 'Success',
            'status' => 200,
            'method' => 'GET',
            'data' => {
                'current log-in user' => {
                    "full_name": getUser.full_name,
                    "username": getUser.username,
                    "email": getUser.email,
                    "password": getUser.password,
                    "gender": getUser.gender
                },
                'profile content' => {
                    'followers ' => followerResponse,
                    'tweets ' => tweetsResponse
                }
            }    
        }  
    end

    def editData_API(params)
        getUser = User.getUserById(params['userId'])

        return {
            'message' => 'user not found',
            'status' => 401,
            'method' => 'POST',
            'data' => params
        } if GeneralController.checkNil(getUser) == true
        
        desc = nil
        if params['description'] == "" || params['description'] == nil
            desc = ""
        else
            desc = params['description']
        end

        alert = nil
        exist = User.checkUser(params['username'])

        if params["username"].include? " "
            alert = "username cannot contain space (' ')"
        elsif !(params['email'].match(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i))
            alert = "wrong email format"
        elsif exist == true && getUser.username != params['username']
            alert = "username already used by other user"
        end

        if alert != nil
            return {
                'message' => alert,
                'status' => 401,
                'method' => 'POST',
                'data' => params
            }
        else
            editUser = User.new(
                userId: params['userId'],
                full_name: params['fullname'],
                username: params['username'],
                email: params['email'],
                description: desc
            )
            editUser.update
            
            result = User.getUserById(params['userId'])
            return {
                'message' => 'Success',
                'status' => 200,
                'method' => 'POST',
                'data' => {
                    "userId": result.userId,
                    "full_name": result.full_name,
                    "username": result.username,
                    "email": result.email,
                    "description": result.description
                }            
            }  
        end

    end

    def otherProfile_API(params)

        alert = nil
        getUser = User.getUserById(params['userId'])
        getOtherUser= User.getUserById(params['otherUsId'])

        if params['userId'] == params['otherUsId']
            alert = "error"
        elsif getUser == nil || getOtherUser == nil
            alert = "user not found"
        end

        return {
            'message' => alert,
            'status' => 401,
            'method' => 'POST',
            'data' => params
        } if alert != nil

        followStatus = Follower.checkFollowStatus(params['userId'],params['otherUsId'])

        followers = Follower.followersListById(params['otherUsId'])
        tweets = Tweet.otherTweetListById(params['otherUsId'],params['userId'])

        tweetsResponse = []
        followerResponse = []

        tweets.each do |tweet|
            tweetsResponse.push({
                "tweetId": tweet.tweetId,
                "userId": [{
                    "userId": tweet.userId.userId,
                    "username": tweet.userId.username,
                    "full_name": tweet.userId.full_name
                }],
                "content": tweet.content,
                "attachment": tweet.attachment,
                "dtm_crt": tweet.dtm_crt,
                "likes": tweet.likes,
                "alreadyLike": tweet.alreadyLike,
                "comments": tweet.comments,
                "hashtags": tweet.hashtags
            })
        end

        followers.each do |follower|
            followerResponse.push({
                "followersId": follower.followersId,
                "userFollowersId": [{
                    "userId": follower.userFollowersId.userId,
                    "username": follower.userFollowersId.username,
                    "full_name": follower.userFollowersId.full_name
                }],
                "dtm_crt": follower.dtm_crt
            })
        end

        return {
            'message' => 'Success',
            'status' => 200,
            'method' => 'GET',
            'data' => {
                'follow status' => followStatus,
                'current log-in user' => {
                    "full_name": getUser.full_name,
                    "username": getUser.username,
                    "email": getUser.email,
                    "password": getUser.password,
                    "gender": getUser.gender
                },
                'profile content' => {
                    'other profile user' => {
                        "full_name": getOtherUser.full_name,
                        "username": getOtherUser.username,
                        "email": getOtherUser.email,
                        "password": getOtherUser.password,
                        "gender": getOtherUser.gender
                    },
                    'followers ' => followerResponse,
                    'tweets ' => tweetsResponse
                }
            }           
        }       
    end

    def editProfPicData_API(params)
        
        getUser = User.getUserById(params['userId'])

        return {
            'message' => 'user not found',
            'status' => 401,
            'method' => 'POST',
            'data' => params
        } if GeneralController.checkNil(getUser) == true
        return {
            'message' => 'no file found',
            'status' => 401,
            'method' => 'POST',
            'data' => params
        } if params[:profilePicture] == nil || params[:profilePicture] == ''

        filename = params[:profilePicture][:filename]
        file = params[:profilePicture][:tempfile]
      
        File.open("./public/transaction/#{filename}", 'wb') do |f|
          f.write(file.read)
        end
        
        updatePicture = User.new(
            userId: getUser.userId,
            full_name: getUser.full_name,
            username: getUser.username,
            email: getUser.email,
            profile_pic: filename
        )
        updatePicture.updateProfilePic

        result = User.getUserById(getUser.userId)
        return {
            'message' => 'Success',
            'status' => 200,
            'method' => 'GET',
            'alert' => '',
            'data' => {
                "userId": result.full_name,
                "full_name": result.full_name,
                "username": result.username,
                "email": result.email,
                "profile_pic": result.profile_pic
            }
        }  
        
    end

end