require './db/db_connector'
require_relative 'user'
require_relative 'liketweet'

class Hashtag
    attr_reader :hashtagId, :hashtagName, :dtm_crt

    def initialize (params)
        @hashtagId = params[:hashtagId]
        @hashtagName = params[:hashtagName]
        @dtm_crt = params[:dtm_crt]
    end

    def self.checkHashtagExist(hashtagName)
        client = create_db_client
        rawData=client.query("""
            select count(*) as checkHashtag
            from hashtags
            where hashtagName = '#{hashtagName}'
            """)
        status = nil
        rawData.each do |data|
            status = data["checkHashtag"]
        end
        return false if status == 0
        return true if status == 1
    end

    def self.getHashtagByName(hashtagName)
        client = create_db_client
        rawData=client.query("""
            select *
            from hashtags
            where hashtagName = '#{hashtagName}'
            """)
        hashtag = nil
        rawData.each do |data|
            hashtag = Hashtag.new(
                hashtagId: data["hashtagId"],
                hashtagName: data["hashtagName"],
                dtm_crt: data["dtm_crt"]
            )
        end
        hashtag
    end

    def self.getHashtagById(id)
        client = create_db_client
        rawData=client.query("""
            select *
            from hashtags
            where hashtagid = #{id}
            """)
        hashtag = nil
        rawData.each do |data|
            hashtag = Hashtag.new(
                hashtagId: data["hashtagId"],
                hashtagName: data["hashtagName"],
                dtm_crt: data["dtm_crt"]
            )
        end
        hashtag
    end

    def save
        return false unless valid?
        client = create_db_client
        rawData=client.query("insert into hashtags (hashtagName,dtm_crt) values (LOWER('#{@hashtagName}'),curdate());")
    end

    def valid?
        return false if @hashtagName.nil?
        return true
    end
end