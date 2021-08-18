require './db/db_connector'
require_relative 'user'
require_relative 'hashtag'

class CommentHashtag
  attr_reader :commentHashtagId, :tweetId, :hashtagId, :dtm_crt

  def initialize(params)
    @commentHashtagId = params[:commentHashtagId]
    @commentTweetId = params[:commentTweetId]
    @hashtagId = params[:hashtagId]
    @dtm_crt = params[:dtm_crt]
  end

  def self.saveToHashtag(hashtagName, commentTweetId)
    arrayHashtag = CommentHashtag.hashtagToArray(hashtagName)
    arrayHashtag.each do |hashtag|
      checker = Hashtag.checkHashtagExist(hashtag)
      getHashtag = nil

      if checker == false
        saveHashtag = Hashtag.new(hashtagName: hashtag)
        saveHashtag.save
      end

      getHashtag = Hashtag.getHashtagByName(hashtag)
      insertCommentHashtag = CommentHashtag.new(
        commentTweetId: commentTweetId,
        hashtagId: getHashtag.hashtagId
      )
      insertCommentHashtag.save
    end
  end

  def self.hashtagToArray(hashtagName)
    hashtagList = []
    hashtagName.split.map do |e|
      if e.include? '#'
        foo = e.to_s.split('#')
        hashtagList.push(foo[1])
      else
        hashtagList.push(e.to_s)
      end
    end
    hashtagList
  end

  def self.getHashtagByCommentTweet(id)
    client = create_db_client
    rawData = client.query("select * from commentHashtag where commentTweetId = #{id}")
    hashtagList = []
    rawData.each do |data|
      hashtag = CommentHashtag.new(
        commentHashtagId: data['commentHashtagId'],
        commentTweetId: data['commentTweetId'],
        hashtagId: Hashtag.getHashtagById(data['hashtagId']),
        dtm_crt: data['dtm_crt']
      )
      hashtagList.push(hashtag)
    end
    hashtagList
  end

  def save
    return false unless valid?
    client = create_db_client
    rawData = client.query("insert into commentHashtag (commentTweetId,hashtagId,dtm_crt) values (#{@commentTweetId},#{@hashtagId},curdate());")
  end

  def valid?
    return false if @commentTweetId.nil?
    return false if @hashtagId.nil?
    true
  end
end
