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



end
