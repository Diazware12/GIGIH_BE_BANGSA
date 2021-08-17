require_relative '../model/tweethashtag'
require_relative '../model/hashtag'
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

    # =================== save data =====================

    describe 'save' do
        context 'when executed' do
            it 'should save data' do
                stub_client = double
                stub_query = "insert into tweetHashtag (tweetId,hashtagId,dtm_crt) values (1,1,curdate());"

                hashtag = TweetHashtag.new(
                    tweetId: 1,
                    hashtagId: 1
                )

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query)
                hashtag.save
            end
        end
    end

    # =================== select data =====================

    describe 'get Hashtag By TweetId' do
        context 'true' do
            it 'there\'s a data' do
                stub_client = double
                stub_query_1 = "select * from tweetHashtag where tweetId = 1"
                stub_query_2 = "select * from hashtags where hashtagid = "
                tweetHashtag = [{
                    "tweetHashtagId": 1, 
                    "tweetId": 1, 
                    "hashtagId": 1, 
                    "dtm_crt": "2021-08-12"
                }]
                hashtag = [{
                    "hashtagId": 1, 
                    "hashtagName": "foo", 
                    "dtm_crt": "2021-08-12"
                }]

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query_1).and_return(tweetHashtag)
                expect(stub_client).to receive(:query).with(stub_query_2).and_return(hashtag)

                tHashtag = TweetHashtag.getHashtagByTweetId(1)
                expect(tHashtag).not_to be_nil
            end
        end

    end

    # =================== hashtag to array =====================
    describe 'hashtag to array' do

        it 'convert to array' do
            result = [
                "generasi",
                "gigih"
            ]
            getResult = TweetHashtag.hashtagToArray("#generasi #gigih")
            expect(getResult).to eq(result)
        end


    end

    describe 'save To Hashtag' do
        context 'when executed' do
            it 'should save To Hashtag' do
                stub_client = double
                stub_query = "select count(*) as checkHashtag from hashtags where hashtagName = 'generasigigih'"
                stub_query_2 = "select * from hashtags where hashtagName = 'generasigigih'"

                tweetHashtag = [{
                    "checkHashtag": 1
                }]

                hashtagData = [{
                    "hashtagId": 1,
                    "hashtagName": "generasigigih",
                    "dtm_crt": "2020-12-23"
                }]

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query).and_return(tweetHashtag)
                expect(stub_client).to receive(:query).with(stub_query_2).and_return(hashtagData)
                insertHashtag = TweetHashtag.saveToHashtag('generasigigih',1)
            end
        end
    end

end
