require_relative '../model/commenthashtag'
require_relative '../db/db_connector'
require 'mysql2'

describe CommentHashtag do

    # =================== valid initialize =====================

    describe '#validCommentHashtag' do
        context 'true' do
            it 'should be true' do
                hashtag = CommentHashtag.new(
                    commentHashtagId: 1,
                    commentTweetId: 2,
                    hashtagId: 3,
                    dtm_crt: "2020-12-23",
                )
                expect(hashtag.valid?).to eq(true)
            end
        end 
        context 'false' do
            it 'should be false' do
                hashtag = CommentHashtag.new(
                    commentHashtagId: 1,
                    commentTweetId: 2,
                    dtm_crt: "2020-12-23",
                )
                expect(hashtag.valid?).to eq(false)
            end
        end 

    end



end
