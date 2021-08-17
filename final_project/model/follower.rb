require './db/db_connector'
require_relative 'user'
require_relative 'tweet'

class Follower
    attr_reader :followersId, :userId, :userFollowersId, :dtm_crt

    def initialize (params)
        @followersId = params[:followersId]
        @userId = params[:userId]
        @userFollowersId = params[:userFollowersId]
        @dtm_crt = params[:dtm_crt]
    end

    def self.followersListById(id)
        client = create_db_client
        rawData=client.query("select * from followers where userId = #{id}")
        followerList = Array.new
        rawData.each do |data|
            user = User.getUserById(data["userFollowersId"])
            followers = Follower.new(
                followersId: data["followersId"],
                userId: data["userId"],
                userFollowersId: user,
                dtm_crt: data["dtm_crt"]
            )
            followerList.push(followers)
        end
        followerList
    end

    def self.checkFollowStatus(userId,otherUserId)
        client = create_db_client
        rawData=client.query("select count(*) as follStatus from followers where userFollowersId = #{userId} and userId = #{otherUserId} ")

        status = nil
        rawData.each do |data|
            status = data["follStatus"]
        end
        
        return true if status == 1
        return false if status == 0
    end

    def self.getFollowerData(userId,otherUserId)
        client = create_db_client
        rawData=client.query("select * from followers where userFollowersId = #{userId} and userId = #{otherUserId}")

        follower = nil
        rawData.each do |data|
            follower = Follower.new(
                followersId: data["followersId"],
                userId: data["userId"],
                userFollowersId: data["userFollowersId"],
                dtm_crt: data["dtm_crt"]
            )
        end
        follower
    end

    def delete
        return false unless valid?
        client = create_db_client
        rawData=client.query("delete from followers where followersId = #{@followersId}")
    end

    def save
        return false unless valid?
        client = create_db_client
        rawData=client.query("insert into followers (userId,userFollowersId,dtm_crt) values (#{@userFollowersId},#{@userId},curdate())")
    end


    def valid?
        return false if @userId.nil?
        return false if @userFollowersId.nil?
        return true
    end
end