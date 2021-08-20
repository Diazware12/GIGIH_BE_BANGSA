require_relative '../controller/tweetcontroller'
require_relative '../model/liketweet'
require_relative '../model/tweet'
require_relative '../db/db_connector'
require 'mysql2'

describe TweetController do
  describe 'like' do
    context 'when executed' do
      it 'should like tweet' do
        stub = double
        controller = TweetController.new

        params = {
          'likeTweetId' => 1,
          'userId' => 1,
          'tweetId' => 1,
          'dtm_crt' => '2020-12-23'
        }

        expect(LikeTweet).to receive(:new).with(params).and_return(stub)
        expect(stub).to receive(:save)

        controller.like(params)

        expect(LikeTweet).to receive(:getSelectedDataForDelete).with(1, 1).and_return(stub)
        result_item = LikeTweet.getSelectedDataForDelete(1, 1)
        expect(result_item).not_to be_nil
      end
    end
    context 'when executed_API' do
      it 'should like tweet' do
        stub = double
        controller = TweetController.new

        params = {
          'likeTweetId' => 1,
          'userId' => 1,
          'tweetId' => 8
        }

        response = {
          'message' => 'Success',
          'status' => 200,
          'method' => 'POST',
          'data' => params
        }

        expect(LikeTweet).to receive(:new).with(params).and_return(stub)
        expect(stub).to receive(:save)

        result = controller.like_API(params)
        expect(result.to_json).to eq(response.to_json)
      end
      it 'shouldn\'t tweet' do
        stub = double
        controller = TweetController.new

        params = {
          'likeTweetId' => 1,
          'userId' => 1,
          'tweetId' => 1
        }

        response = {
          'message' => 'you already like this tweet',
          'status' => 401,
          'method' => 'POST',
          'data' => params
        }
        result = controller.like_API(params)
        expect(result.to_json).to eq(response.to_json)
      end
    end
  end

  describe 'delete tweet' do
    context 'when executed' do
      it 'should delete tweet' do
        stub = double
        controller = TweetController.new

        params = {
          'tweetId' => 1
        }

        createTweet = Tweet.new(
          userId: 1,
          content: 'only for testing',
          attachment: '/attachment/foo.jpg',
          hashtags: 'haha'
        )

        stub_query = 'delete from tweets where tweetId = ;'
        allow(Mysql2::Client).to receive(:new).and_return(stub)
        expect(Tweet).to receive(:getTweet).with(1).and_return(createTweet)
        expect(stub).to receive(:query).with(stub_query)
        expect(Tweet).to receive(:getTweet).with(1).and_return(nil)

        controller.deleteTweet(params)

        result = Tweet.getTweet(1)

        expect(result).to be_nil
      end
    end
  end

  describe 'dislike tweet' do
    context 'when executed' do
      it 'should dislike tweet' do
        stub = double
        controller = TweetController.new

        params = {
          'userId' => 1,
          'tweetId' => 1
        }

        createLikeTweet = LikeTweet.new(
          likeTweetId: 1,
          userId: 1,
          tweetId: 1,
          dtm_crt: '2020-12-23'
        )

        stub_query = 'delete from liketweets where likeTweetId = 1;'
        allow(Mysql2::Client).to receive(:new).and_return(stub)
        expect(LikeTweet).to receive(:getSelectedDataForDelete).with(1, 1).and_return(createLikeTweet)
        expect(stub).to receive(:query).with(stub_query)
        expect(LikeTweet).to receive(:getSelectedDataForDelete).with(1, 1).and_return(nil)

        controller.dislike(params)

        result = LikeTweet.getSelectedDataForDelete(1, 1)

        expect(result).to be_nil
      end
    end
    context 'when executed_API' do
      it 'should dislike tweet' do
        stub = double
        controller = TweetController.new

        params = {
          'likeTweetId' => 1,
          'userId' => 1,
          'tweetId' => 8
        }

        response = {
          'message' => 'Success',
          'status' => 200,
          'method' => 'POST',
          'data' => params
        }

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

        checkLike = [{
          "checkLike": 1
        }]

        liketweetData = [{
          "likeTweetId": 1,
          "userId": 1,
          "tweetId": 1,
          "dtm_crt": "2020-12-23"
        }]

        stub_query_2= 'select * from users where userId = 1'
        stub_query_3= 'select count(*) as checkLike from liketweets where userId = 1 and tweetId = 8'
        stub_query_4= 'select * from liketweets where userId = 1 and tweetId = 8'
        allow(Mysql2::Client).to receive(:new).and_return(stub)
        expect(stub).to receive(:query).with(stub_query_2).and_return(users)
        expect(stub).to receive(:query).with(stub_query_3).and_return(checkLike)
        expect(stub).to receive(:query).with(stub_query_4).and_return(liketweetData)

        result = controller.dislike_API(params)
        expect(result.to_json).to eq(response.to_json)
      end
    end
  end
end
