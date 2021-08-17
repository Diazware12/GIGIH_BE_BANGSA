require_relative '../model/commenttweet'
require_relative '../db/db_connector'
require 'mysql2'

describe CommentTweet do

    # =================== valid initialize =====================

    describe '#validCommentTweet' do
        context 'true' do
            it 'should be true' do
                tweet = CommentTweet.new(
                    commentTweetId: 1,
                    userId: 1,
                    tweetId: 2,
                    comment_tweet: "only for test purposes",
                    hashtags: "#Generasi #Gigih",
                    dtm_crt: "2020-12-23",
                    attachment: "/transaction/foo.jpg"
                )
                expect(tweet.valid?).to eq(true)
            end
        end 
        context 'false' do
            it 'should be false' do
                tweet = CommentTweet.new(
                    commentTweetId: 1,
                    userId: 1,
                    hashtags: "#Generasi #Gigih",
                    dtm_crt: "2020-12-23",
                    attachment: "/transaction/foo.jpg"
                )
                expect(tweet.valid?).to eq(false)
            end
        end 

    end

    describe 'comment Tweet List By Id' do
        context 'true' do
            it 'there\'s a data' do
                stub_client = double
                stub_query_1 = "select * from commenttweets where tweetId = 1"
                stub_query_2 = "select * from users where userId = "
                stub_query_3 = "select * from commentHashtag where commentTweetId = "
                stub_query_4 = "select * from hashtags where hashtagid = "
                
                comment = [{
                    "commentTweetId": 1, 
                    "userId": 1, 
                    "tweetId": 1, 
                    "comment_tweet": "only for testing purposes",
                    "dtm_crt": "2020-12-23",
                    "attachment": "/transaction/test.jpg"
                }]

                users = [{
                    "userId": 1, 
                    "full_name": "Martin Garrix", 
                    "username": "mGrix99", 
                    "email": "mGrix99@gmail.com", 
                    "password": "mGrix99",
                    "gender": "Male", 
                    "profile_pic": "/transaction/1-mGrix99.jpg", 
                    "role": "User",
                    "dtm_crt": "2021-08-12"
                }]

                commentHashtag = [{
                    "commentHashtagId": 1, 
                    "commentTweetId": 1, 
                    "hashtagId": 1, 
                    "dtm_crt": "2020-12-23"
                }]

                hashtag = [{
                    "hashtagId": 1, 
                    "hashtagName": "generasigigih", 
                    "dtm_crt": "2020-12-23"
                }]


                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query_1).and_return(comment)
                expect(stub_client).to receive(:query).with(stub_query_2).and_return(users)
                expect(stub_client).to receive(:query).with(stub_query_3).and_return(commentHashtag)
                expect(stub_client).to receive(:query).with(stub_query_4).and_return(hashtag)

                commentTweet = CommentTweet.commentTweetListById(1)
                expect(commentTweet).not_to be_nil
            end
        end

    end
    
end
