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
  end
end
