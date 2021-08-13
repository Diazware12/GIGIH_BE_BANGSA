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
        rawData=client.query("""
            select * from followers	
            where userId = #{id}
        """)

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

    def valid?
        return false if @userId.nil?
        return false if @userFollowersId.nil?
        return true
    end
end