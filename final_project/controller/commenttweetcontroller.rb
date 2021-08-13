require './model/user'
require './model/commenttweet'
require './model/liketweet'

class CommentTweetController

    def createCommentTweet(params)
        comment = CommentTweet.new(
            userId: params['usId'],
            tweetId: params['tweetId'],
            comment_tweet: params['comment_tweet'],
            hashtags: params['hashtags']
        )
        comment.save
    end

end