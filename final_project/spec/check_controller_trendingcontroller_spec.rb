require_relative '../controller/trendingcontroller'
require_relative '../model/liketweet'
require_relative '../model/tweet'
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
        hashtagList = Hashtag.trending
        result = controller.trendingPage(params)

        expected_view = ERB.new(File.read('views/trending.erb')).result(binding)
        expect(result).to eq(expected_view)
      end
    end
  end
end
