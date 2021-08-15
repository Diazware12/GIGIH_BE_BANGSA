require './model/user'
require './model/tweet'
require './model/liketweet'

class TweetController

    def like(params)
        likeProcess = LikeTweet.new(
            userId: params['usId'],
            tweetId: params['tweetId']
        )
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

    def dislike(params)
        likeProcess = LikeTweet.getSelectedDataForDelete(params['usId'],params['tweetId'])
        likeProcess.delete
    end

end