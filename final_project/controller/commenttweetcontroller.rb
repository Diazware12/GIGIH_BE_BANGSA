require './model/user'
require './model/commenttweet'
require './model/liketweet'

class CommentTweetController

    def createCommentTweet(params)

        filename = params[:file][:filename]
        file = params[:file][:tempfile]
      
        File.open("./public/transaction/#{filename}", 'wb') do |f|
          f.write(file.read)
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

end