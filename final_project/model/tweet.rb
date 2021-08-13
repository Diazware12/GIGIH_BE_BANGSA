require './db/db_connector'
require_relative 'user'
require_relative 'liketweet'

class Tweet
    attr_reader :tweetId, :userId, :content, :attachment, :dtm_crt, :likes, :alreadyLike, :comments

    def initialize (params)
        @tweetId = params[:tweetId]
        @userId = params[:userId]
        @content = params[:content]
        @attachment = params[:attachment]
        @dtm_crt = params[:dtm_crt]
        @likes = params[:likes]
        @alreadyLike = params[:alreadyLike]
        @comments = params[:comments]
    end

    def self.tweetListById(id)
        client = create_db_client
        rawData=client.query("""
            select
                (@x:=t.tweetId) as tweetId,
                u.userId as userId,
                t.content,
                t.attachment,
                t.dtm_crt,
                (
                    select count(*) from commenttweets
                    where tweetId = (@x) 
                ) as comments
                from tweets as t join
                users as u on t.userId = u.userId
                where u.userId = #{id}
            """)
        tweetList = Array.new

        rawData.each do |data|
            user = User.getUserById(data["userId"])
            tweet = Tweet.new(
                tweetId: data["tweetId"],
                userId: user,
                content: data["content"],
                attachment: data["attachment"],
                dtm_crt: data["dtm_crt"],
                likes: LikeTweet.likesData(data["tweetId"]),
                alreadyLike: LikeTweet.checkUserLikedStatus(id,data["tweetId"]),
                comments: data["comments"]
            )
            tweetList.push(tweet)
        end
        tweetList
    end

    def valid?
        return false if @userId.nil?
        return false if @content.nil?
        return true
    end
end