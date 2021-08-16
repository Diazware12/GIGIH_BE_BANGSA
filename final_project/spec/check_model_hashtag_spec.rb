require_relative '../model/hashtag'
require_relative '../db/db_connector'
require 'mysql2'

describe Hashtag do

    # =================== valid initialize =====================

    describe '#validLikeTweet' do
        context 'true' do
            it 'should be true' do
                hashtag = Hashtag.new(
                    hashtagId: 1,
                    hashtagName: "#generasigigih",
                    dtm_crt: "2020-12-23"
                )
                expect(hashtag.valid?).to eq(true)
            end
        end 
        context 'false' do
            it 'should be false' do
                hashtag = Hashtag.new(
                    hashtagId: 1,
                    dtm_crt: "2020-12-23"
                )
                expect(hashtag.valid?).to eq(false)
            end
        end 

    end



end
