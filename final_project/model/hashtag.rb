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

    def self.searchHashtag(keyword)
        client = create_db_client
        rawData=client.query("""
                select 
                (@x:=h.hashtagId) as hashtagId,
                h.hashtagName,
                h.dtm_crt
                from hashtags as h
                where h.hashtagName like '%#{keyword}%'
                group by h.hashtagId
                order by h.dtm_crt
            """)
        hashtagList = Array.new

        rawData.each do |data|
            hashtag = Hashtag.new(
                hashtagId: data["hashtagId"],
                hashtagName: data["hashtagName"],
                dtm_crt: data["dtm_crt"],
                totalUsage: Hashtag.getSumUser(data["hashtagId"])
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
                h.dtm_crt
                from hashtags as h
                group by h.hashtagId
                order by h.dtm_crt
            """)
        hashtagList = Array.new

        rawData.each do |data|
            hashtag = Hashtag.new(
                hashtagId: data["hashtagId"],
                hashtagName: data["hashtagName"],
                dtm_crt: data["dtm_crt"],
                totalUsage: Hashtag.getSumUser(data["hashtagId"])
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
                HOUR(TIMEDIFF(curdate(), h.dtm_crt)) as test
                from hashtags as h
                having test = 24
                limit 5
            """)
        hashtagList = Array.new

        rawData.each do |data|
            hashtag = Hashtag.new(
                hashtagId: data["hashtagId"],
                hashtagName: data["hashtagName"],
                dtm_crt: data["dtm_crt"],
                totalUsage: Hashtag.getSumUser(data["hashtagId"])
            )
            hashtagList.push(hashtag)
        end
        hashtagList
    end

    def self.getSumUser(id)
        client = create_db_client
        rawData=client.query("""
                select 
                sum((
                    select count(*) from
                    tweetHashtag where hashtagId = #{id}
                )+(
                    select count(*) from
                    commentHashtag where hashtagId = #{id}
                )) as totalUse
                from hashtags
                where hashtagId = #{id}
            """)
        sum = nil
        rawData.each do |data|
            sum = data["totalUse"]
        end
        sum
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