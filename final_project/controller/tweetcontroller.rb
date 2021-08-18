require './model/user'
require './model/tweet'
require './model/liketweet'
require_relative 'generalcontroller'

class TweetController
  def like(params)
    likeProcess = LikeTweet.new(params)
    likeProcess.save
  end

  def createTweet(params)
    textContent = params['content']
    return false if textContent.length > 1000

    unless params[:file].nil?
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
      hashtags: params['hashtags']
    )
    createTweet.save
  end

  def deleteTweet(params)
    tweet = Tweet.getTweet(params['tweetId'])
    tweet.delete
  end

  def dislike(params)
    likeProcess = LikeTweet.getSelectedDataForDelete(params['userId'], params['tweetId'])
    likeProcess.delete
  end

  # API Test

  def createTweet_API(params)
    textContent = params['content']
    if params['content'].length > 1000
      return {
        'message' => 'comment character cannot more than 1000 character',
        'status' => 401,
        'method' => 'POST',
        'data' => params
      }
    end

    getUser = User.getUserById(params['userId'])

    if GeneralController.checkNil(getUser) == true
      return {
        'message' => 'user not found',
        'status' => 401,
        'method' => 'POST',
        'data' => params
      }
    end

    unless params[:file].nil?
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
      hashtags: params['hashtags']
    )
    createTweet.save

    {
      'message' => 'Success',
      'status' => 200,
      'method' => 'POST',
      'alert' => '',
      'redirect' => 'mainpage',
      'data' => params
    }
  end

  def like_API(params)
    if GeneralController.checkNil(User.getUserById(params['userId'])) == true
      return {
        'message' => 'user not found',
        'status' => 401,
        'method' => 'POST',
        'data' => params
      }
    end

    if GeneralController.checkNil(Tweet.getTweet(params['tweetId'])) == true
      return {
        'message' => 'tweet not found :(',
        'status' => 401,
        'method' => 'POST',
        'data' => params
      }
    end

    if LikeTweet.checkUserLikedStatus(params['userId'], params['tweetId']) == true
      return {
        'message' => 'you already like this tweet',
        'status' => 401,
        'method' => 'POST',
        'data' => params
      }
    end

    likeProcess = LikeTweet.new(params)
    likeProcess.save

    {
      'message' => 'Success',
      'status' => 200,
      'method' => 'POST',
      'data' => params
    }
  end

  def dislike_API(params)
    if GeneralController.checkNil(User.getUserById(params['userId'])) == true
      return {
        'message' => 'user not found',
        'status' => 401,
        'method' => 'POST',
        'data' => params
      }
    end

    if GeneralController.checkNil(Tweet.getTweet(params['tweetId'])) == true
      return {
        'message' => 'tweet not found :(',
        'status' => 401,
        'method' => 'POST',
        'data' => params
      }
    end

    if LikeTweet.checkUserLikedStatus(params['userId'], params['tweetId']) == false
      return {
        'message' => 'you didn\'n like this tweet before',
        'status' => 401,
        'method' => 'POST',
        'data' => params
      }
    end

    likeProcess = LikeTweet.getSelectedDataForDelete(params['userId'], params['tweetId'])
    likeProcess.delete

    {
      'message' => 'Success',
      'status' => 200,
      'method' => 'POST',
      'data' => params
    }
  end

  def deleteTweet_API(params)
    getUser = User.getUserById(params['userId'])
    tweet = Tweet.getTweet(params['tweetId'])

    if GeneralController.checkNil(getUser) == true
      return {
        'message' => 'user not found',
        'status' => 401,
        'method' => 'POST',
        'data' => params
      }
    end

    if GeneralController.checkNil(tweet) == true
      return {
        'message' => 'tweet not found :(',
        'status' => 401,
        'method' => 'POST',
        'data' => params
      }
    end

    if getUser.userId != tweet.userId.userId
      return {
        'message' => 'you\'re not allowed to delete',
        'status' => 401,
        'method' => 'POST',
        'data' => params
      }
    end

    tweet.delete

    {
      'message' => 'Success',
      'status' => 200,
      'method' => 'POST',
      'data' => params
    }
  end
end
