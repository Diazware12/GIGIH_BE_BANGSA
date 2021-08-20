require './db/db_connector'
require_relative 'user'

class LikeTweet
  attr_reader :likeTweetId, :userId, :tweetId, :dtm_crt

  def initialize(params)
    @likeTweetId = params[:likeTweetId]
    @userId = params[:userId]
    @tweetId = params[:tweetId]
    @dtm_crt = params[:dtm_crt]
  end

  def self.likesData(id)
    client = create_db_client
    rawData = client.query("select * from liketweets where tweetId = #{id}")
    liketweets = []
    rawData.each do |data|
      user = User.getUserById(data['userId'])
      like = LikeTweet.new(
        likeTweetId: data['likeTweetId'],
        userId: user,
        tweetId: data['tweetId'],
        dtm_crt: data['dtm_crt']
      )
      liketweets.push(like)
    end
    liketweets
  end

  def self.checkUserLikedStatus(userId, tweetId)
    client = create_db_client
    rawData = client.query("select count(*) as checkLike from liketweets where userId = #{userId} and tweetId = #{tweetId}")
    status = nil
    rawData.each do |data|
      status = data['checkLike']
    end
    return false if status == 0
    return true if status == 1
  end

  def self.getSelectedDataForDelete(userId, tweetId)
    client = create_db_client
    rawData = client.query("select * from liketweets where userId = #{userId} and tweetId = #{tweetId}")
    getLikeTweet = nil
    rawData.each do |data|
      getLikeTweet = LikeTweet.new(
        likeTweetId: data['likeTweetId'],
        userId: data['userId'],
        tweetId: data['tweetId'],
        dtm_crt: data['dtm_crt']
      )
    end
    getLikeTweet
  end

  def save
    return false unless valid?
    client = create_db_client
    rawData = client.query("insert into liketweets (userId,tweetId,dtm_crt) values (#{@userId},#{@tweetId},curdate());")
  end

  def delete
    return false unless valid?
    client = create_db_client
    rawData = client.query("delete from liketweets where likeTweetId = #{@likeTweetId};")
  end

  def valid?
    return false if @userId.nil?
    return false if @tweetId.nil?
    true
  end
end
