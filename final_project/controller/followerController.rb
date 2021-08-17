require './model/user'
require './model/tweet'
require './model/liketweet'
require './model/commenttweet'
require './model/follower'

class FollowerController

    def follow(params)
        saveFollower = Follower.new(params)
        saveFollower.save
    end

    def unfollow(params)
        getFollower = Follower.getFollowerData(params["userId"],params["userFollowersId"])
        getFollower.delete
    end

end