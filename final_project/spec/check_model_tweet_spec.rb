require_relative '../model/tweet'
require_relative '../db/db_connector'
require 'mysql2'

describe Tweet do
  # =================== valid initialize =====================

  describe '#validtweet' do
    context 'true' do
      it 'should be true' do
        tweet = Tweet.new(
          tweetId: 1,
          userId: 2,
          content: 'only for test purposes',
          attachment: '/transaction/foo.jpg',
          dtm_crt: '2020-12-23'
        )
        expect(tweet.valid?).to eq(true)
      end
    end
    context 'false' do
      it 'should be false' do
        tweet = Tweet.new(
          tweetId: 1,
          userId: 2,
          attachment: '/transaction/foo.jpg',
          dtm_crt: '2020-12-23'
        )
        expect(tweet.valid?).to eq(false)
      end
    end
  end

  describe '#savetweet' do
    context 'true' do
      it 'should be true' do
        stub_client = double
        stub_query = "insert into tweets (userId,content,dtm_crt) values (1,'only for testing',curdate());"

        getTweet = Tweet.new(
          userId: 1,
          content: 'only for testing'
        )
        allow(Mysql2::Client).to receive(:new).and_return(stub_client)
        expect(stub_client).to receive(:query).with(stub_query)
        getTweet.save
      end
    end
    context 'false' do
      it 'shouldn\'t be true' do
        stub_client = double
        stub_query = "insert into tweets (userId,content,dtm_crt) values (1,'only for testing',curdate());"

        getTweet = Tweet.new(
          userId: 1
        )
        expect(getTweet.valid?).to eq(false)
      end
    end
  end

  describe '#deletetweet' do
    context 'true' do
      it 'should be true' do
        stub_client = double
        stub_query = 'delete from tweets where tweetId = 1;'

        tweet = Tweet.new(
          tweetId: 1,
          userId: 2,
          content: 'only for test purposes',
          attachment: '/transaction/foo.jpg',
          dtm_crt: '2020-12-23'
        )

        allow(Mysql2::Client).to receive(:new).and_return(stub_client)
        expect(stub_client).to receive(:query).with(stub_query)
        tweet.delete
      end
    end
    context 'false' do
      it 'should be false' do
        stub_client = double
        stub_query = 'delete from tweets where tweetId = 1;'

        tweet = Tweet.new(
          tweetId: 1,
          dtm_crt: '2020-12-23'
        )

        expect(tweet.valid?).to eq(false)
      end
    end
  end
end
