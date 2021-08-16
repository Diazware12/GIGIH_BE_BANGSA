require_relative '../model/tweethashtag'
require_relative '../db/db_connector'
require 'mysql2'

describe TweetHashtag do

    # =================== valid initialize =====================
    describe '#validtweethashtag' do
        context 'true' do
            it 'should be true' do
                hashtag = TweetHashtag.new(
                    tweetHashtagId: 1,
                    tweetId: 1,
                    hashtagId: 2,
                    dtm_crt: "2020-12-23"
                )
                expect(hashtag.valid?).to eq(true)
            end
        end 
        context 'false' do
            it 'should be false' do
                hashtag = TweetHashtag.new(
                    tweetHashtagId: 1,
                    tweetId: 1,
                    dtm_crt: "2020-12-23"
                )
                expect(hashtag.valid?).to eq(false)
            end
        end 

    end
end
