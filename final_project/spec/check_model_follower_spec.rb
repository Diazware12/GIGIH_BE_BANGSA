require_relative '../model/follower'
require_relative '../db/db_connector'
require 'mysql2'

describe Follower do

    # =================== valid initialize =====================

    describe '#validfollower' do
        context 'true' do
            it 'should be true' do
                follower = Follower.new(
                    followersId: 1,
                    userId: 2,
                    userFollowersId: 2,
                    dtm_crt: "2020-12-23"
                )
                expect(follower.valid?).to eq(true)
            end
        end 
        context 'false' do
            it 'should be false' do
                follower = Follower.new(
                    followersId: 1,
                    userId: 2,
                    dtm_crt: "2020-12-23"
                )
                expect(follower.valid?).to eq(false)
            end
        end 
    end

    describe 'save' do
        context 'when executed' do
            it 'should save data' do
                stub_client = double
                stub_query = "insert into followers (userId,userFollowersId,dtm_crt) values (1,1,curdate())"

                follower = Follower.new(
                    userId: 1,
                    userFollowersId: 1
                )

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query)
                follower.save
            end
        end
    end

    describe 'get Followers By Id' do
        context 'true' do
            it 'there\'s a data' do
                stub_client = double
                stub_query_1 = "select * from followers where userId = 1"
                stub_query_2 = "select * from users where userId = "
                
                getFollowers = [{
                    "followersId": 1, 
                    "userId": 1, 
                    "userFollowersId":1, 
                    "dtm_crt": "2020-12-23", 
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
                    "dtm_crt": "2021-08-12" 
                }]

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query_1).and_return(getFollowers)
                expect(stub_client).to receive(:query).with(stub_query_2).and_return(users)


                followers = Follower.followersListById(1)
                expect(followers).not_to be_nil
            end
        end

    end

    describe 'Check follow status' do
        context 'true' do
            it 'there\'s a data' do
                stub_client = double
                stub_query_1 = "select count(*) as follStatus from followers where userFollowersId = 1 and userId = 2 "
                
                getStatus = [{
                    "follStatus": 1, 
                }]

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query_1).and_return(getStatus)


                followers = Follower.checkFollowStatus(1,2)
                expect(followers).to eq(nil)
            end
        end

    end

    describe 'get Followers Data' do
        context 'true' do
            it 'there\'s a data' do
                stub_client = double
                stub_query_1 = "select * from followers where userFollowersId = 1 and userId = 2"
                
                getFollowers = [{
                    "followersId": 1, 
                    "userId": 2, 
                    "userFollowersId":1, 
                    "dtm_crt": "2020-12-23"
                }]

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query_1).and_return(getFollowers)

                followers = Follower.getFollowerData(1,2)
                expect(followers).not_to be_nil
            end
        end

    end

    describe 'delete' do
        context 'when executed' do
            it 'should delete data' do
                stub_client = double
                stub_query = "delete from followers where followersId = 1"

                follower = Follower.new({
                    followersId: 1, 
                    userId: 2, 
                    userFollowersId: 1, 
                    dtm_crt: "2021-08-12"
                })

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query)
                follower.delete
            end
        end
    end

end
