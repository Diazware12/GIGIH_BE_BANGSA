require_relative '../model/tweet'
require_relative '../db/db_connector'
require 'mysql2'

describe Tweet do

    # =================== valid initialize =====================

    describe '#validtweet' do
        context 'true' do
            it 'should be true' do
                tweet = Tweet.new(
                    tweetId: 1,
                    userId: 2,
                    content: "only for test purposes",
                    attachment: "/transaction/foo.jpg",
                    dtm_crt: "2020-12-23",
                )
                expect(tweet.valid?).to eq(true)
            end
        end 
        context 'false' do
            it 'should be false' do
                tweet = Tweet.new(
                    tweetId: 1,
                    userId: 2,
                    attachment: "/transaction/foo.jpg",
                    dtm_crt: "2020-12-23",
                )
                expect(tweet.valid?).to eq(false)
            end
        end 

    end



end
