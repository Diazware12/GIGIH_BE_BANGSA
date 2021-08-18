require_relative '../controller/usercontroller'
require_relative '../model/user'
require_relative '../db/db_connector'
require 'mysql2'

describe UserController do
  describe 'login' do
    context 'when executed' do
      it 'should show login page' do
        controller = UserController.new
        result = controller.loginPage

        alert = nil
        expected_view = ERB.new(File.read('views/login.erb')).result(binding)
        expect(result).to eq(expected_view)
      end
    end
  end

  describe 'register' do
    context 'open regist page' do
      it 'should show regist page' do
        controller = UserController.new
        params = {}
        result = controller.registerPage(params, 'page')

        alert = nil
        expected_view = ERB.new(File.read('views/register.erb')).result(binding)
        expect(result).to eq(expected_view)
      end
    end
  end

  describe 'homepage' do
    context 'open home page' do
      it 'should show homepage' do
        stub = double

        controller = UserController.new
        params = {
          'userId' => 1
        }
        tweetList = Tweet.tweetList(1)
        getUser = User.getUserById(1)
        result = controller.homepage(params)

        expected_view = ERB.new(File.read('views/index.erb')).result(binding)
        expect(result).to eq(expected_view)
      end
    end
  end

  describe 'comment' do
    context 'open comment page' do
      it 'should show comment' do
        stub = double

        controller = UserController.new

        params = { 'userId' => '1', 'tweetId' => '1' }

        getTweet = Tweet.getTweet(1)
        commentList = CommentTweet.commentTweetListById(1)
        getUser = User.getUserById(1)

        result = controller.commentPage(params)

        expected_view = ERB.new(File.read('views/comment.erb')).result(binding)
        expect(result).to eq(expected_view)
      end
    end
  end

  describe 'edit profile data' do
    context 'open edit profile data page' do
      it 'should show edit profile data' do
        stub = double

        controller = UserController.new

        params = { 'userId' => '1' }

        getUser = User.getUserById(1)

        result = controller.editPage(params)

        expected_view = ERB.new(File.read('views/edituserdata.erb')).result(binding)
        expect(result).to eq(expected_view)
      end
    end
  end

  describe 'edit profile picture' do
    context 'open edit profile picture page' do
      it 'should show edit profile picture' do
        stub = double

        controller = UserController.new

        params = { 'userId' => '1' }

        getUser = User.getUserById(1)

        result = controller.editProfPicPage(params)

        expected_view = ERB.new(File.read('views/editprofilepicture.erb')).result(binding)
        expect(result).to eq(expected_view)
      end
    end
  end
end
