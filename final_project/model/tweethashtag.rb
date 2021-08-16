require './db/db_connector'
require_relative 'user'
require_relative 'hashtag'

class TweetHashtag
    attr_reader :tweetHashtagId, :tweetId, :hashtagId, :dtm_crt

    def initialize (params)
        @tweetHashtagId = params[:tweetHashtagId]
        @tweetId = params[:tweetId]
        @hashtagId = params[:hashtagId]
        @dtm_crt = params[:dtm_crt]
    end

    def self.saveToHashtag(hashtagName,tweetId)
        arrayHashtag = TweetHashtag.hashtagToArray(hashtagName)
        arrayHashtag.each do |hashtag|
            
            checker = Hashtag.checkHashtagExist(hashtag)
            getHashtag = nil

            if checker == false
                saveHashtag = Hashtag.new(hashtagName: hashtag)
                saveHashtag.save
            end

            getHashtag = Hashtag.getHashtagByName(hashtag)
            insertTweetHashtag = TweetHashtag.new(
                tweetId: tweetId,
                hashtagId: getHashtag.hashtagId
            )
            insertTweetHashtag.save
        end
    end

    def self.hashtagToArray(hashtagName)
        hashtagList = []
        hashtagName.split.map do |e|
            if e.include? "#"
                foo = "#{e}".split('#')
                hashtagList.push(foo[1])  
            else 
                hashtagList.push("#{e}")
            end
        end
        return hashtagList
    end

    def self.getHashtagByTweetId(id)
        client = create_db_client
        rawData=client.query("select * from tweetHashtag where tweetId = #{id}")
        hashtagList = Array.new
        rawData.each do |data|
            hashtag = TweetHashtag.new(
                tweetHashtagId: data["tweetHashtagId"],
                tweetId: data["tweetId"],
                hashtagId: Hashtag.getHashtagById(data["hashtagId"]),
                dtm_crt: data["dtm_crt"],
            )
            hashtagList.push(hashtag)
        end
        hashtagList
    end

    def save
        return false unless valid?
        client = create_db_client
        rawData=client.query("insert into tweetHashtag (tweetId,hashtagId,dtm_crt) values (#{@tweetId},#{@hashtagId},curdate());")
    end

    def valid?
        return false if @tweetId.nil?
        return false if @hashtagId.nil?
        return true
    end
end