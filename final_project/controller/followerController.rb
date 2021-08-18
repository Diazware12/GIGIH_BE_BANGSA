require './model/user'
require './model/tweet'
require './model/liketweet'
require './model/commenttweet'
require './model/follower'

require_relative 'generalcontroller'

class FollowerController

    def follow(params)
        saveFollower = Follower.new(params)
        saveFollower.save
    end

    def unfollow(params)
        getFollower = Follower.getFollowerData(params["userId"],params["userFollowersId"])
        getFollower.delete
    end

    #API Testing
    def follow_API(params)
        return {
            'message' => 'user not found',
            'status' => 401,
            'method' => 'POST',
            'data' => params
        } if GeneralController.checkNil(User.getUserById(params['userId'])) == true || GeneralController.checkNil(User.getUserById(params['userFollowersId'])) == true
 
        getFollower = Follower.getFollowerData(params["userId"],params["userFollowersId"])
        return {
            'message' => 'you already follow this user before',
            'status' => 401,
            'method' => 'POST',
            'data' => params
        } if GeneralController.checkNil(getFollower) == false

        saveFollower = Follower.new(params)
        saveFollower.save

        return {
            'message' => 'Success',
            'status' => 200,
            'method' => 'POST',
            'data' => params
        }
    end

    def unfollow_API(params)
        return {
            'message' => 'user not found',
            'status' => 401,
            'method' => 'POST',
            'data' => params
        } if GeneralController.checkNil(User.getUserById(params['userId'])) == true || GeneralController.checkNil(User.getUserById(params['userFollowersId'])) == true
 
        getFollower = Follower.getFollowerData(params["userId"],params["userFollowersId"])

        return {
            'message' => 'you\'re not followed this user before',
            'status' => 401,
            'method' => 'POST',
            'data' => params
        } if GeneralController.checkNil(getFollower) == true

        getFollower.delete

        return {
            'message' => 'Success',
            'status' => 200,
            'method' => 'POST',
            'data' => params
        }
    end

end