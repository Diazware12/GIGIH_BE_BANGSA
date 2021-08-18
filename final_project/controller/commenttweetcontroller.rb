require './model/user'
require './model/commenttweet'
require './model/liketweet'

class CommentTweetController

    def createCommentTweet(params)

        return false if params['comment_tweet'].length > 1000 

        if params[:file] != nil
            filename = params[:file][:filename]
            file = params[:file][:tempfile]
        
            File.open("./public/transaction/#{filename}", 'wb') do |f|
            f.write(file.read)
            end
        end

        comment = CommentTweet.new(
            userId: params['userId'],
            tweetId: params['tweetId'],
            comment_tweet: params['comment_tweet'],
            hashtags: params['hashtags'],
            attachment: filename
        )
        comment.save
    end


    #API test
    def createCommentTweet_API (params)

        getUser = User.getUserById(params['userId'])

        return {
            'message' => 'comment character cannot more than 1000 character',
            'status' => 401,
            'method' => 'POST',
            'data' => params
        } if params['comment_tweet'].length > 1000

        if params[:file] != nil
            filename = params[:file][:filename]
            file = params[:file][:tempfile]
        
            File.open("./public/transaction/#{filename}", 'wb') do |f|
            f.write(file.read)
            end
        end

        comment = CommentTweet.new(
            userId: params['userId'],
            tweetId: params['tweetId'],
            comment_tweet: params['comment_tweet'],
            hashtags: params['hashtags'],
            attachment: filename
        )
        comment.save

        return {
            'message' => 'Success',
            'status' => 200,
            'method' => 'POST',
            'alert' => '',
            'redirect' => 'commentpage',
            'Current Log-In User' => {
                "full_name": getUser.full_name,
                "username": getUser.username,
                "email": getUser.email,
                "password": getUser.password,
                "gender": getUser.gender
            },
            'data' => params
        }
    end

end