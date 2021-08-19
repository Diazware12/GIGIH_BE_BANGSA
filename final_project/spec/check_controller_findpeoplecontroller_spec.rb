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
          'userId' => 1
        }

        getUser = User.getUserById(1)
        peopleList = User.userList

        result = controller.findPeople(params)

        expected_view = ERB.new(File.read('views/findpeople.erb')).result(binding)
        expect(result).to eq(expected_view)
      end
    end
    context 'with searching' do
      it 'should show user list' do
        controller = FindPeopleController.new
        params = {
          'userId' => 1,
          'searchUser' => 'Martin Garrix'
        }

        getUser = User.getUserById(1)
        peopleList = User.searchUser('Martin Garrix')

        result = controller.findPeople(params)

        expected_view = ERB.new(File.read('views/findpeople.erb')).result(binding)
        expect(result).to eq(expected_view)
      end
    end

    context 'no searching_API' do
      it 'should show user list' do
        controller = FindPeopleController.new
        params = {
          'userId' => 1
        }

        getUser = User.getUserById(1)
        peoples = User.userList

        results = []

        peoples.each do |people|
          results.push({
            'userId': people.userId,
            'full_name': people.full_name,
            'username': people.username,
            'email': people.email,
            'password': people.password,
            'gender': people.gender,
            'profile_pic': people.profile_pic,
            'role': people.role,
            'dtm_crt': people.dtm_crt,
          })
        end

        response = {
          'message' => 'Success',
          'status' => 200,
          'method' => 'POST',
          'data' => {
            "Current Log-In User" => {
              "full_name": getUser.full_name,
              "username": getUser.username,
              "email": getUser.email,
              "password": getUser.password,
              "gender": getUser.gender
            },
            'users' => results  
          }
        }

        result = controller.findPeople_API(params)
        expect(result.to_json).to eq(response.to_json)
      end
    end
    context 'with searching_API' do
      it 'should show user list' do
        controller = FindPeopleController.new
        params = {
          'userId' => 1,
          'searchUser' => 'test'
        }

        getUser = User.getUserById(1)
        peoples = User.searchUser(params['searchUser'])

        results = []

        peoples.each do |people|
          results.push({
            'userId': people.userId,
            'full_name': people.full_name,
            'username': people.username,
            'email': people.email,
            'password': people.password,
            'gender': people.gender,
            'profile_pic': people.profile_pic,
            'role': people.role,
            'dtm_crt': people.dtm_crt,
          })
        end

        response = {
          'message' => 'Success',
          'status' => 200,
          'method' => 'POST',
          'data' => {
            "Current Log-In User" => {
              "full_name": getUser.full_name,
              "username": getUser.username,
              "email": getUser.email,
              "password": getUser.password,
              "gender": getUser.gender
            },
            'users' => results  
          }
        }

        result = controller.findPeople_API(params)
        expect(result.to_json).to eq(response.to_json)
      end
    end
  end
end
