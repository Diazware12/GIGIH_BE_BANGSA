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



end
