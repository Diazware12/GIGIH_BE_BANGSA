require './model/user'
require './model/hashtag'

require './model/tweet'
require './model/commenttweet'

class ExploreController

    def details(params)
        getUser = User.getUserById(params['userId'])
        hashtagData = Hashtag.getHashtagById(params['hashtagId'])

        tweetList = Tweet.tweetListByHashtag(params['userId'],params['hashtagId'])

        commentTweetList = CommentTweet.commentTweetListByHashtag(params['hashtagId'])

        renderer = ERB.new(File.read("views/hashtagdetails.erb"))
        renderer.result(binding)  
    end
end