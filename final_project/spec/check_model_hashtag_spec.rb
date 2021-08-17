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

    describe 'check Hashtag Exist' do
        context 'true' do
            it 'there\'s a data' do
                stub_client = double
                stub_query_1 = "select count(*) as checkHashtag from hashtags where hashtagName = 'generasigigih'"
                
                hashtagExist = [{
                    "checkHashtag": 1, 
                }]

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query_1).and_return(hashtagExist)


                hashtag = Hashtag.checkHashtagExist("generasigigih")
                expect(hashtag).to eq(nil)
            end
        end

    end

    describe 'get Hashtag By Name' do
        context 'true' do
            it 'there\'s a data' do
                stub_client = double
                stub_query_1 = "select * from hashtags where hashtagName = 'generasigigih'"
                
                getHashtag = [{
                    "hashtagId": 1, 
                    "hashtagName": "generasigigih", 
                    "dtm_crt": "2020-12-23", 
                }]

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query_1).and_return(getHashtag)


                hashtag = Hashtag.getHashtagByName("generasigigih")
                expect(hashtag).not_to be_nil
            end
        end

    end

    describe 'get Hashtag By Id' do
        context 'true' do
            it 'there\'s a data' do
                stub_client = double
                stub_query_1 = "select * from hashtags where hashtagid = 1"
                
                getHashtag = [{
                    "hashtagId": 1, 
                    "hashtagName": "generasigigih", 
                    "dtm_crt": "2020-12-23", 
                }]

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query_1).and_return(getHashtag)


                hashtag = Hashtag.getHashtagById(1)
                expect(hashtag).not_to be_nil
            end
        end

    end

    describe 'trending hashtag' do
        context 'true' do
            it 'there\'s a data' do
                stub_client = double
                stub_query_1 = "select (@x:=h.hashtagId) as hashtagId,h.hashtagName,h.dtm_crt,FORMAT(((select count(*) from tweetHashtag where hashtagId = (@x))+(select count(*) from commentHashtag where hashtagId = (@x))),0) as totalUse,HOUR(TIMEDIFF(curdate(), h.dtm_crt)) as trendDate from hashtags as h having trendDate = 24 and totalUse != 0 order by totalUse desc limit 5"
                
                trendHashtag = [{
                    "hashtagId": 1, 
                    "hashtagName": "generasigigih", 
                    "dtm_crt": "2020-12-23", 
                    "totalUse": 2, 
                    "trendDate": 24
                }]

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query_1).and_return(trendHashtag)


                hashtag = Hashtag.trending
                expect(hashtag).not_to be_nil
            end
        end

    end

end
