require './model/user'
require './model/tweet'
require './model/liketweet'

class TweetController

    def like(params)
        likeProcess = LikeTweet.new(params)
        likeProcess.save
    end

    def createTweet(params)
        
        textContent = params['content']
        return false if textContent.length > 1000

        filename = params[:file][:filename]
        file = params[:file][:tempfile]
      
        File.open("./public/transaction/#{filename}", 'wb') do |f|
          f.write(file.read)
        end

        createTweet = Tweet.new(
            userId: params['usId'],
            content: params['content'],
            attachment: filename,
            hashtags: params['hashtags'],
        )
        createTweet.save
    end

    def deleteTweet(params)
        tweet = Tweet.getTweet(params["tweetId"])
        tweet.delete
    end
    
    def dislike(params)
        likeProcess = LikeTweet.getSelectedDataForDelete(params['userId'],params['tweetId'])
        likeProcess.delete
    end

end