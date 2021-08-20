require './db/db_connector'
require_relative 'user'
require_relative 'liketweet'
require_relative 'tweethashtag'

class Tweet
  attr_reader :tweetId, :userId, :content, :attachment, :dtm_crt, :likes, :alreadyLike, :comments, :hashtags

  def initialize(params)
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

  def self.tweetList(id)
    client = create_db_client
    rawData = client.query("select (@x:=t.tweetId) as tweetId,u.userId as userId,t.content,t.attachment,t.dtm_crt,(select count(*) from liketweets where tweetId = (@x) ) as likes,(select count(*) from commenttweets where tweetId = (@x) ) as comments from tweets as t join users as u on t.userId = u.userId left join followers as f on u.userId = f.userId where u.userId = #{id} or f.userFollowersId = #{id} order by likes desc")
    tweetList = []

    rawData.each do |data|
      user = User.getUserById(data['userId'])
      tweet = Tweet.new(
        tweetId: data['tweetId'],
        userId: user,
        content: data['content'],
        attachment: data['attachment'],
        dtm_crt: data['dtm_crt'],
        likes: LikeTweet.likesData(data['tweetId']),
        alreadyLike: LikeTweet.checkUserLikedStatus(id, data['tweetId']),
        comments: data['comments'],
        hashtags: TweetHashtag.getHashtagByTweetId(data['tweetId'])
      )
      tweetList.push(tweet)
    end
    tweetList
  end

  def self.tweetListById(id)
    client = create_db_client
    rawData = client.query(''"
        select
            (@x:=t.tweetId) as tweetId,
            u.userId as userId,
            t.content,
            t.attachment,
            t.dtm_crt,
            (
                select count(*) from liketweets
                where tweetId = (@x)
            ) as likes,
            (
                select count(*) from commenttweets
                where tweetId = (@x)
            ) as comments
            from tweets as t join
            users as u on t.userId = u.userId
            where u.userId = #{id}
            order by likes desc
        "'')
    tweetList = []

    rawData.each do |data|
      user = User.getUserById(data['userId'])
      tweet = Tweet.new(
        tweetId: data['tweetId'],
        userId: user,
        content: data['content'],
        attachment: data['attachment'],
        dtm_crt: data['dtm_crt'],
        likes: LikeTweet.likesData(data['tweetId']),
        alreadyLike: LikeTweet.checkUserLikedStatus(id, data['tweetId']),
        comments: data['comments'],
        hashtags: TweetHashtag.getHashtagByTweetId(data['tweetId'])
      )
      tweetList.push(tweet)
    end
    tweetList
  end

  def self.otherTweetListById(id, userId)
    client = create_db_client
    rawData = client.query(''"
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
        "'')
    tweetList = []

    rawData.each do |data|
      user = User.getUserById(data['userId'])
      tweet = Tweet.new(
        tweetId: data['tweetId'],
        userId: user,
        content: data['content'],
        attachment: data['attachment'],
        dtm_crt: data['dtm_crt'],
        likes: LikeTweet.likesData(data['tweetId']),
        alreadyLike: LikeTweet.checkUserLikedStatus(userId, data['tweetId']),
        comments: data['comments'],
        hashtags: TweetHashtag.getHashtagByTweetId(data['tweetId'])
      )
      tweetList.push(tweet)
    end
    tweetList
  end

  def self.tweetListByHashtag(usId, hashtagId)
    client = create_db_client
    rawData = client.query(''"
        select
        (@x:=t.tweetId) as tweetId,
        u.userId as userId,
        t.content,
        t.attachment,
        t.dtm_crt,
        (
            select count(*) from liketweets
            where tweetId = (@x)
        ) as likes,
        (
            select count(*) from commenttweets
            where tweetId = (@x)
        ) as comments
        from tweets as t
        join tweetHashtag as th on t.tweetId = th.tweetId
        join users as u on t.userId = u.userId
        where th.hashtagId = #{hashtagId}
        order by likes desc
        "'')

    tweetList = []

    rawData.each do |data|
      user = User.getUserById(data['userId'])
      tweet = Tweet.new(
        tweetId: data['tweetId'],
        userId: user,
        content: data['content'],
        attachment: data['attachment'],
        dtm_crt: data['dtm_crt'],
        likes: LikeTweet.likesData(data['tweetId']),
        alreadyLike: LikeTweet.checkUserLikedStatus(usId, data['tweetId']),
        comments: data['comments'],
        hashtags: TweetHashtag.getHashtagByTweetId(data['tweetId'])
      )
      tweetList.push(tweet)
    end
    tweetList
  end

  def self.getTweet(id)
    client = create_db_client
    rawData = client.query(''"
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
        "'')
    response = nil
    rawData.each do |data|
      user = User.getUserById(data['userId'])
      response = Tweet.new(
        tweetId: data['tweetId'],
        userId: user,
        content: data['content'],
        attachment: data['attachment'],
        dtm_crt: data['dtm_crt'],
        likes: LikeTweet.likesData(data['tweetId']),
        alreadyLike: LikeTweet.checkUserLikedStatus(id, data['tweetId']),
        comments: data['comments'],
        hashtags: TweetHashtag.getHashtagByTweetId(data['tweetId'])
      )
    end
    response
  end

  def save
    return false unless valid?
    client = create_db_client
    if @attachment.nil?
      rawData = client.query("insert into tweets (userId,content,dtm_crt) values (#{@userId},'#{@content}',curdate());")
    else
      rawData = client.query("insert into tweets (userId,content,attachment,dtm_crt) values (#{@userId},'#{@content}','/transaction/#{@attachment['filename']}',curdate());")
    end

    if !@hashtags.nil? || !@hashtags == ''
      tweetid = client.last_id
      insertHashtag = TweetHashtag.saveToHashtag(@hashtags, tweetid)
    end
  end

  def delete
    return false unless valid?
    client = create_db_client
    rawData = client.query("delete from tweets where tweetId = #{@tweetId};")
  end

  def valid?
    return false if @userId.nil?
    return false if @content.nil?
    true
  end
end
