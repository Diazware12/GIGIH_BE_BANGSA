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

    # =================== save =====================

    describe 'save' do
        context 'when executed' do
            it 'should save data' do
                stub_client = double
                stub_query = "insert into hashtags (hashtagName,dtm_crt) values (LOWER('generasigigih'),curdate());"

                saveHashtag = Hashtag.new(
                    hashtagName: 'generasigigih'
                )

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query)
                saveHashtag.save
            end
        end
    end


end
