require './model/user'
require './model/tweet'
require './model/liketweet'
require './model/commenttweet'
require './model/follower'

class FollowerController

    def follow(params)
        saveFollower = Follower.new(
            userId:params["usId"],
            userFollowersId:params["otherUsId"]
        )
        saveFollower.save
    end

    def unfollow(params)
        getFollower = Follower.getFollowerData(params["usId"],params["otherUsId"])
        getFollower.delete
    end

end