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
    getFollower = Follower.getFollowerData(params['userId'], params['userFollowersId'])
    getFollower.delete
  end

  # API Testing
  def follow_API(params)
    if GeneralController.checkNil(User.getUserById(params['userId'])) == true || GeneralController.checkNil(User.getUserById(params['userFollowersId'])) == true
      return {
        'message' => 'user not found',
        'status' => 401,
        'method' => 'POST',
        'data' => params
      }
    end

    getFollower = Follower.getFollowerData(params['userId'], params['userFollowersId'])
    if GeneralController.checkNil(getFollower) == false
      return {
        'message' => 'you already follow this user before',
        'status' => 401,
        'method' => 'POST',
        'data' => params
      }
    end

    saveFollower = Follower.new(params)
    saveFollower.save

    {
      'message' => 'Success',
      'status' => 200,
      'method' => 'POST',
      'data' => params
    }
  end

  def unfollow_API(params)
    if GeneralController.checkNil(User.getUserById(params['userId'])) == true || GeneralController.checkNil(User.getUserById(params['userFollowersId'])) == true
      return {
        'message' => 'user not found',
        'status' => 401,
        'method' => 'POST',
        'data' => params
      }
    end

    getFollower = Follower.getFollowerData(params['userId'], params['userFollowersId'])

    if GeneralController.checkNil(getFollower) == true
      return {
        'message' => 'you\'re not followed this user before',
        'status' => 401,
        'method' => 'POST',
        'data' => params
      }
    end

    getFollower.delete

    {
      'message' => 'Success',
      'status' => 200,
      'method' => 'POST',
      'data' => params
    }
  end
end
