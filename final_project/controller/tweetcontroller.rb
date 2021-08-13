require './model/user'
require './model/tweet'
require './model/liketweet'

class TweetController

    def like(params)
        likeProcess = LikeTweet.new(
            userId: params['usId'],
            tweetId: params['tweetId']
        )
        likeProcess.save
    end

    def dislike(params)
        likeProcess = LikeTweet.getSelectedDataForDelete(params['usId'],params['tweetId'])
        likeProcess.delete
    end

end