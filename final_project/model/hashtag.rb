require './db/db_connector'
require_relative 'user'
require_relative 'liketweet'

class Hashtag
    attr_reader :hashtagId, :hashtagName, :dtm_crt, :totalUsage

    def initialize (params)
        @hashtagId = params[:hashtagId]
        @hashtagName = params[:hashtagName]
        @dtm_crt = params[:dtm_crt]
        @totalUsage = params[:totalUsage]
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
        rawData=client.query("select * from hashtags where hashtagid = #{id}")
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

    def self.searchHashtag(keyword)
        client = create_db_client
        rawData=client.query("""
                select 
                (@x:=h.hashtagId) as hashtagId,
                h.hashtagName,
                h.dtm_crt,
                FORMAT(
                    (
                        (	
                            select count(*) from
                            tweetHashtag where hashtagId = (@x)
                        )+(
                            select count(*) from
                            commentHashtag where hashtagId = (@x)
                        )
                    ),0
                ) as totalUse
                from hashtags as h
                where h.hashtagName like '%#{keyword}%'
            """)
        hashtagList = Array.new

        rawData.each do |data|
            hashtag = Hashtag.new(
                hashtagId: data["hashtagId"],
                hashtagName: data["hashtagName"],
                dtm_crt: data["dtm_crt"],
                totalUsage: data["totalUse"]
            )
            hashtagList.push(hashtag)
        end
        hashtagList
    end

    def self.hashtagList
        client = create_db_client
        rawData=client.query("""
                select 
                (@x:=h.hashtagId) as hashtagId,
                h.hashtagName,
                h.dtm_crt,
                FORMAT(
                    (
                        (	
                            select count(*) from
                            tweetHashtag where hashtagId = (@x)
                        )+(
                            select count(*) from
                            commentHashtag where hashtagId = (@x)
                        )
                    ),0
                ) as totalUse
                from hashtags as h
                order by totalUse desc
            """)
        hashtagList = Array.new

        rawData.each do |data|
            hashtag = Hashtag.new(
                hashtagId: data["hashtagId"],
                hashtagName: data["hashtagName"],
                dtm_crt: data["dtm_crt"],
                totalUsage: data["totalUse"]
            )
            hashtagList.push(hashtag)
        end
        hashtagList
    end

    def self.trending
        client = create_db_client
        rawData=client.query("""
                select 
                (@x:=h.hashtagId) as hashtagId,
                h.hashtagName,
                h.dtm_crt,
                FORMAT(
                    (
                        (	
                            select count(*) from
                            tweetHashtag where hashtagId = (@x)
                        )+(
                            select count(*) from
                            commentHashtag where hashtagId = (@x)
                        )
                    ),0
                ) as totalUse,
                HOUR(TIMEDIFF(curdate(), h.dtm_crt)) as trendDate
                from hashtags as h
                having trendDate = 24 and totalUse != 0
                order by totalUse desc
                limit 5
            """)
        hashtagList = Array.new

        rawData.each do |data|
            hashtag = Hashtag.new(
                hashtagId: data["hashtagId"],
                hashtagName: data["hashtagName"],
                dtm_crt: data["dtm_crt"],
                totalUsage: data["totalUse"]
            )
            hashtagList.push(hashtag)
        end
        hashtagList
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