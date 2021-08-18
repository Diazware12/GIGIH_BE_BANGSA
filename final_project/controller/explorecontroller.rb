require './model/user'
require './model/hashtag'

require './model/tweet'
require './model/commenttweet'
require_relative 'generalcontroller'

class ExploreController
  def details(params)
    getUser = User.getUserById(params['userId'])
    hashtagData = Hashtag.getHashtagById(params['hashtagId'])

    tweetList = Tweet.tweetListByHashtag(params['userId'], params['hashtagId'])

    commentTweetList = CommentTweet.commentTweetListByHashtag(params['hashtagId'])

    renderer = ERB.new(File.read('views/hashtagdetails.erb'))
    renderer.result(binding)
  end

  #API Test
  def details_API(params)
    getUser = User.getUserById(params['userId'])
    hashtagData = Hashtag.getHashtagById(params['hashtagId'])

    return {
      'message' => 'user not found',
      'status' => 401,
      'method' => 'POST',
      'data' => params
    }if GeneralController.checkNil(getUser) == true

    return {
      'message' => 'hashtag data not found',
      'status' => 401,
      'method' => 'POST',
      'data' => params
    }if GeneralController.checkNil(hashtagData) == true

    tweets = Tweet.tweetListByHashtag(params['userId'], params['hashtagId'])

    comments = CommentTweet.commentTweetListByHashtag(params['hashtagId'])

    tweetResponse = []
    commentTweetResponse = []

    tweets.each do |tweet|
      tweetResponse.push({
          "tweetId": tweet.tweetId,
          "userId": [{
              "userId": tweet.userId.userId,
              "username": tweet.userId.username,
              "full_name": tweet.userId.full_name
          }],
          "content": tweet.content,
          "attachment": tweet.attachment,
          "dtm_crt": tweet.dtm_crt,
          "likes": tweet.likes,
          "alreadyLike": tweet.alreadyLike,
          "comments": tweet.comments,
          "hashtags": tweet.hashtags
      })
    end

    comments.each do |comments|
      commentTweetResponse.push({
          "commentTweetId": comments.commentTweetId,
          "userId": [{
              "userId": comments.userId.userId,
              "username": comments.userId.username,
              "full_name": comments.userId.full_name
          }],
          "tweetId": comments.tweetId,
          "comment_tweet": comments.comment_tweet,
          "hashtags": comments.hashtags,
          "dtm_crt": comments.dtm_crt,
          "attachment": comments.attachment
      })
    end

    {
      'message' => 'Success',
      'status' => 200,
      'method' => 'POST',
      'data' => {
        "Current Log-In User" => {
          "full_name": getUser.full_name,
          "username": getUser.username,
          "email": getUser.email,
          "password": getUser.password,
          "gender": getUser.gender
        },
        'Tweet List' => tweetResponse,
        'Comment List' => commentTweetResponse 
      }
    }
  end
end
