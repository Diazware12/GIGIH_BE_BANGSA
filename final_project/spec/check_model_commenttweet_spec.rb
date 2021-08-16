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



end
