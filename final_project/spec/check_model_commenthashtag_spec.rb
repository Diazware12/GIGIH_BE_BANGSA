require_relative '../model/commenthashtag'
require_relative '../db/db_connector'
require 'mysql2'

describe CommentHashtag do

    # =================== valid initialize =====================

    describe '#validCommentHashtag' do
        context 'true' do
            it 'should be true' do
                hashtag = CommentHashtag.new(
                    commentHashtagId: 1,
                    commentTweetId: 2,
                    hashtagId: 3,
                    dtm_crt: "2020-12-23",
                )
                expect(hashtag.valid?).to eq(true)
            end
        end 
        context 'false' do
            it 'should be false' do
                hashtag = CommentHashtag.new(
                    commentHashtagId: 1,
                    commentTweetId: 2,
                    dtm_crt: "2020-12-23",
                )
                expect(hashtag.valid?).to eq(false)
            end
        end 

    end


    describe 'save' do
        context 'when executed' do
            it 'should save data' do
                stub_client = double
                stub_query = "insert into commentHashtag (commentTweetId,hashtagId,dtm_crt) values (1,1,curdate());"

                cHashtag = CommentHashtag.new(
                    commentTweetId: 1,
                    hashtagId: 1
                )

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query)
                cHashtag.save
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
            getResult = CommentHashtag.hashtagToArray("#generasi #gigih")
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
                insertHashtag = CommentHashtag.saveToHashtag('generasigigih',1)
            end
        end
    end


end
