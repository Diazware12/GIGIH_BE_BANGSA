require_relative '../model/liketweet'
require_relative '../db/db_connector'
require 'mysql2'

describe LikeTweet do

    # =================== valid initialize =====================

    describe '#validLikeTweet' do
        context 'true' do
            it 'should be true' do
                like = LikeTweet.new(
                    likeTweetId: 1,
                    userId: 1,
                    tweetId: 2,
                    dtm_crt: "2020-12-23"
                )
                expect(like.valid?).to eq(true)
            end
        end 
        context 'false' do
            it 'should be false' do
                like = LikeTweet.new(
                    likeTweetId: 1,
                    tweetId: 2,
                    dtm_crt: "2020-12-23"
                )
                expect(like.valid?).to eq(false)
            end
        end 

    end



end
