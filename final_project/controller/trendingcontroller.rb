require './model/user'
require './model/hashtag'

require './model/tweet'
require './model/commenttweet'
require_relative 'generalcontroller'

class TrendingController
  def trendingPage(params)
    getUser = User.getUserById(params['userId'])

    hashtags = Hashtag.trending
    renderer = ERB.new(File.read('views/trending.erb'))
    renderer.result(binding)
  end

  #API Test
  def trendingPage_API(params)
    getUser = User.getUserById(params['userId'])

    return {
      'message' => 'user not found',
      'status' => 401,
      'method' => 'POST',
      'data' => params
    }if GeneralController.checkNil(getUser) == true

    hashtags = Hashtag.trending
    
    trendings = []

    hashtags.each do |hashtag|
      trendings.push({
        "hashtagId": hashtag.hashtagId,
        "hashtagName": hashtag.hashtagName,
        "dtm_crt": hashtag.dtm_crt,
        "totalUsage": hashtag.totalUsage
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
        'trending list' => trendings
      }
    }
  end
end
