require_relative '../model/liketweet'
require_relative '../model/user'
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

    describe 'save' do
        context 'when executed' do
            it 'should save data' do
                stub_client = double
                stub_query = "insert into liketweets (userId,tweetId,dtm_crt) values (1,1,curdate());"

                saveLikeTweet = LikeTweet.new(
                    userId: 1,
                    tweetId: 1
                )

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query)
                saveLikeTweet.save
            end
        end
    end

    describe 'get like data' do
        context 'when executed' do
            it 'should select data' do
                stub_client = double
                stub_query_1 = "select * from liketweets where tweetId = 1"
                stub_query_2 = "select * from users where userId = "

                like = [{
                    "likeTweetId": 1, 
                    "userId": 1, 
                    "tweetId": 1, 
                    "dtm_crt": "2021-08-12"
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
                    "dtm_crt": "2021-08-12",
                    "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod", 
                }]

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query_1).and_return(like)
                expect(stub_client).to receive(:query).with(stub_query_2).and_return(users)

                getLikeTweet = LikeTweet.likesData(1)
                expect(getLikeTweet).not_to be_nil
            end
        end
    end

    describe 'get data for delete' do
        context 'when executed' do
            it 'should select data' do
                stub_client = double
                stub_query_1 = "select * from liketweets where userId = 1 and tweetId = 1"
                stub_query_2 = "select * from users where userId = "

                like = [{
                    "likeTweetId": 1, 
                    "userId": 1, 
                    "tweetId": 1, 
                    "dtm_crt": "2021-08-12"
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
                    "dtm_crt": "2021-08-12",
                    "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod", 
                }]

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query_1).and_return(like)
                expect(stub_client).to receive(:query).with(stub_query_2).and_return(users)

                getLikeTweet = LikeTweet.getSelectedDataForDelete(1,1)
                expect(getLikeTweet).not_to be_nil
            end
        end
    end
    
    describe 'check User Like Status' do
        context 'when executed' do
            it 'should select data' do
                stub_client = double
                stub_query_1 = "select count(*) as checkLike from liketweets where userId = 1 and tweetId = 1"

                like = [{
                    "checkLike": 0
                }]


                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query_1).and_return(like)

                getLikeTweet = LikeTweet.checkUserLikedStatus(1,1)
                expect(getLikeTweet).to eq(nil)
            end
        end
    end

    describe 'delete' do
        context 'when executed' do
            it 'should delete data' do
                stub_client = double
                stub_query = "delete from liketweets where likeTweetId = 1;"

                like = LikeTweet.new({
                    likeTweetId: 1, 
                    userId: 1, 
                    tweetId: 1, 
                    dtm_crt: "2021-08-12"
                })

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query)
                like.delete
            end
        end
    end


end
