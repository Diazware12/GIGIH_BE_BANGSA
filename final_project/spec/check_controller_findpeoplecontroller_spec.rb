require_relative '../controller/findpeoplecontroller'
require_relative '../model/liketweet'
require_relative '../model/follower'
require_relative '../db/db_connector'
require 'mysql2'

describe FindPeopleController do

    describe 'find people' do
        context 'no searching' do
            it 'should show user list' do

                controller = FindPeopleController.new
                params = {
                    "userId"=> 1
                }
                
                getUser = User.getUserById(1)
                peopleList = User.userList

                result = controller.findPeople(params)

                expected_view = ERB.new(File.read("views/findpeople.erb")).result(binding)
                expect(result).to eq(expected_view)
            end
        end
        context 'with searching' do
            it 'should show user list' do

                controller = FindPeopleController.new
                params = {
                    "userId"=> 1,
                    "searchUser"=> "Martin Garrix"
                }
                
                getUser = User.getUserById(1)
                peopleList = User.searchUser("Martin Garrix")

                result = controller.findPeople(params)

                expected_view = ERB.new(File.read("views/findpeople.erb")).result(binding)
                expect(result).to eq(expected_view)
            end
        end
    end
end
