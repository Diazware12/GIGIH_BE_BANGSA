require './model/user'
require './model/hashtag'

require './model/tweet'
require './model/commenttweet'

class TrendingController
    def trendingPage(params)
        getUser = User.getUserById(params['userId'])

        hashtagList = Hashtag.trending
        renderer = ERB.new(File.read("views/trending.erb"))
        renderer.result(binding)  

    end
end