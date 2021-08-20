require_relative '../controller/trendingcontroller'
require_relative '../model/liketweet'
require_relative '../model/tweet'
require_relative '../model/hashtag'
require_relative '../db/db_connector'
require 'mysql2'

describe TrendingController do
  describe 'page' do
    context 'when executed' do
      it 'should show page' do
        controller = TrendingController.new

        params = {
          'userId' => 1
        }

        getUser = User.getUserById(1)
        hashtags = Hashtag.trending
        result = controller.trendingPage(params)

        expected_view = ERB.new(File.read('views/trending.erb')).result(binding)
        expect(result).to eq(expected_view)
      end
    end
    context 'when executed_API' do
      it 'should show trending list' do
        controller = TrendingController.new
        params = {
          'userId' => 1
        }

        getUser = User.getUserById(1)
        hashtags = Hashtag.trending
    
        trendings = []
    
        hashtags.each do |hashtag|
          trendings.push({
            "hashtagId": hashtag.hashtagId,
            "hashtagName": hashtag.hashtagName,
            "dtm_crt": hashtag.dtm_crt,
            "totalUsage": hashtag.totalUsage
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
            'trending list' => trendings
          }
        }

        result = controller.trendingPage_API(params)
        expect(result.to_json).to eq(response.to_json)
      end
    end
  end
end
