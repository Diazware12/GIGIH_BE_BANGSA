require './db/db_connector'
require_relative 'user'
require_relative 'liketweet'
require_relative 'tweethashtag'

class Tweet
    attr_reader :tweetId, :userId, :content, :attachment, :dtm_crt, :likes, :alreadyLike, :comments, :hashtags

    def initialize (params)
        @tweetId = params[:tweetId]
        @userId = params[:userId]
        @content = params[:content]
        @attachment = params[:attachment]
        @dtm_crt = params[:dtm_crt]
        @likes = params[:likes]
        @alreadyLike = params[:alreadyLike]
        @comments = params[:comments]
        @hashtags = params[:hashtags]
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
                comments: data["comments"],
                hashtags: TweetHashtag.getHashtag(data["tweetId"])
            )
            tweetList.push(tweet)
        end
        tweetList
    end

    def self.getTweet(id)
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
                where tweetId = #{id}
            """)
        response = nil
        rawData.each do |data|
            user = User.getUserById(data["userId"])
            response = Tweet.new(
                tweetId: data["tweetId"],
                userId: user,
                content: data["content"],
                attachment: data["attachment"],
                dtm_crt: data["dtm_crt"],
                likes: LikeTweet.likesData(data["tweetId"]),
                alreadyLike: LikeTweet.checkUserLikedStatus(id,data["tweetId"]),
                comments: data["comments"],
                hashtags: TweetHashtag.getHashtag(data["tweetId"])
            )
        end
        response
    end

    def save
        return false unless valid?
        client = create_db_client
        rawData=client.query("insert into tweets (userId,content,dtm_crt) values (#{@userId},'#{@content}',curdate());")
        
        tweetid = client.last_id
        if !@hashtags.nil? || !@hashtags == ""
            insertHashtag = TweetHashtag.saveToHashtag(@hashtags,tweetid)
        end
    end

    def valid?
        return false if @userId.nil?
        return false if @content.nil?
        return true
    end
end