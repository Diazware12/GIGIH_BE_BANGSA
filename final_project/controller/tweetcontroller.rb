require './model/user'
require './model/tweet'
require './model/liketweet'

class TweetController

    def like(params)
        likeProcess = LikeTweet.new(params)
        likeProcess.save
    end

    def createTweet(params)
        
        textContent = params['content']
        return false if textContent.length > 1000

        if params[:file] != nil
            filename = params[:file][:filename]
            file = params[:file][:tempfile]
        
            File.open("./public/transaction/#{filename}", 'wb') do |f|
            f.write(file.read)
            end
        end

        createTweet = Tweet.new(
            userId: params['userId'],
            content: params['content'],
            attachment: filename,
            hashtags: params['hashtags'],
        )
        createTweet.save
    end

    def deleteTweet(params)
        tweet = Tweet.getTweet(params["tweetId"])
        tweet.delete
    end
    
    def dislike(params)
        likeProcess = LikeTweet.getSelectedDataForDelete(params['userId'],params['tweetId'])
        likeProcess.delete
    end

    #API Test

    def createTweet_API(params)
        
        textContent = params['content']
        return {
            'message' => 'comment character cannot more than 1000 character',
            'status' => 401,
            'method' => 'POST',
            'data' => params
        } if params['content'].length > 1000

        getUser = User.getUserById(params['userId'])
        
        return {
            'message' => 'user not found',
            'status' => 401,
            'method' => 'POST',
            'data' => params
        } if getUser == nil || getUser == ''

        if params[:file] != nil
            filename = params[:file][:filename]
            file = params[:file][:tempfile]
        
            File.open("./public/transaction/#{filename}", 'wb') do |f|
            f.write(file.read)
            end
        end

        createTweet = Tweet.new(
            userId: params['userId'],
            content: params['content'],
            attachment: filename,
            hashtags: params['hashtags'],
        )
        createTweet.save

        return {
            'message' => 'Success',
            'status' => 200,
            'method' => 'POST',
            'alert' => '',
            'redirect' => 'mainpage',
            'data' => params
        }
    end

    def like_API(params)

        return {
            'message' => 'user not found',
            'status' => 401,
            'method' => 'POST',
            'data' => params
        } if User.getUserById(params['userId']) == nil || User.getUserById(params['userId']) == ''

        return {
            'message' => 'tweet not found :(',
            'status' => 401,
            'method' => 'POST',
            'data' => params
        }if Tweet.getTweet(params['tweetId']) == nil || Tweet.getTweet(params['tweetId']) == ''

        return {
            'message' => 'you already like this tweet',
            'status' => 401,
            'method' => 'POST',
            'data' => params
        }if LikeTweet.checkUserLikedStatus(params["userId"],params["tweetId"]) == true


        likeProcess = LikeTweet.new(params)
        likeProcess.save

        return {
            'message' => 'Success',
            'status' => 200,
            'method' => 'POST',
            'data' => params
        }
    end

    def dislike_API(params)

        return {
            'message' => 'user not found',
            'status' => 401,
            'method' => 'POST',
            'data' => params
        } if User.getUserById(params['userId']) == nil || User.getUserById(params['userId']) == ''

        return {
            'message' => 'tweet not found :(',
            'status' => 401,
            'method' => 'POST',
            'data' => params
        }if Tweet.getTweet(params['tweetId']) == nil || Tweet.getTweet(params['tweetId']) == ''

        return {
            'message' => 'you didn\'n like this tweet before',
            'status' => 401,
            'method' => 'POST',
            'data' => params
        }if LikeTweet.checkUserLikedStatus(params["userId"],params["tweetId"]) == false


        likeProcess = LikeTweet.getSelectedDataForDelete(params['userId'],params['tweetId'])
        likeProcess.delete

        return {
            'message' => 'Success',
            'status' => 200,
            'method' => 'POST',
            'data' => params
        }
    end

    def deleteTweet_API(params)

        getUser = User.getUserById(params['userId'])
        tweet = Tweet.getTweet(params["tweetId"])

        return {
            'message' => 'user not found',
            'status' => 401,
            'method' => 'POST',
            'data' => params
        } if getUser == nil || getUser == ''

        return {
            'message' => 'tweet not found :(',
            'status' => 401,
            'method' => 'POST',
            'data' => params
        }if tweet == nil || tweet == ''

        return {
            'message' => 'you\'re not allowed to delete',
            'status' => 401,
            'method' => 'POST',
            'data' => params
        }if getUser.userId != tweet.userId.userId

        tweet.delete

        return {
            'message' => 'Success',
            'status' => 200,
            'method' => 'POST',
            'data' => params
        }
    end

end