require_relative '../controller/usercontroller'
require_relative '../model/user'
require_relative '../db/db_connector'
require 'mysql2'
require 'json'

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
    context 'when login' do
      it 'should show home page' do
        controller = UserController.new
        params = {
          'username' => 'diazware12',
          'password' => 'diazware12'
        }

        getUser = User.getUser('diazware12','diazware12')
        tweetList = Tweet.tweetList(getUser.userId)
        result = controller.loginUser(params)

        alert = nil
        expected_view = ERB.new(File.read('views/index.erb')).result(binding)
        expect(result).to eq(expected_view)
      end
      it 'user not found' do
        controller = UserController.new
        params = {
          'username' => 'ff',
          'password' => 'diazware12'
        }

        getUser = User.getUser('ff','diazware12')
        result = controller.loginUser(params)

        alert = "username didn't found or registered"
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
    context 'submit regist' do
      it 'should submit regist' do
        stub = double
        controller = UserController.new

        params = {
          'full_name' => 'martin garrix',
          'username' => 'mGarrix12',
          'email' => 'mGarrix12@gmail.com',
          'password' => 'mGarrix12',
          'conpass' => 'mGarrix12',
          'gender' => 'Male'
        }

        expect(User).to receive(:new).with(params).and_return(stub)
        expect(stub).to receive(:save)

        controller.registerPage(params, 'submit')
      end
      it 'password & confirmation not same' do
        stub = double
        controller = UserController.new

        params = {
          'full_name' => 'martin garrix',
          'username' => 'mGarrix12',
          'email' => 'mGarrix12@gmail.com',
          'password' => 'mGarrix12',
          'conpass' => 'mGarrix',
          'gender' => 'Male'
        }

        result = controller.registerPage(params, 'submit')
        alert = 'Confirm password should be same as password'
        expected_view = ERB.new(File.read('views/register.erb')).result(binding)
        expect(result).to eq(expected_view)
      end
      it 'username cannot contain space' do
        stub = double
        controller = UserController.new

        params = {
          'full_name' => 'martin garrix',
          'username' => 'm Garrix12',
          'email' => 'mGarrix12@gmail.com',
          'password' => 'mGarrix12',
          'conpass' => 'mGarrix12',
          'gender' => 'Male'
        }

        result = controller.registerPage(params, 'submit')
        alert = "username cannot contain space (' ')"
        expected_view = ERB.new(File.read('views/register.erb')).result(binding)
        expect(result).to eq(expected_view)
      end
      it 'username already exist' do
        stub = double
        controller = UserController.new

        params = {
          'full_name' => 'martin garrix',
          'username' => 'diazware12',
          'email' => 'mGarrix12@gmail.com',
          'password' => 'mGarrix12',
          'conpass' => 'mGarrix12',
          'gender' => 'Male'
        }

        result = controller.registerPage(params, 'submit')
        alert = "username already used by other user"
        expected_view = ERB.new(File.read('views/register.erb')).result(binding)
        expect(result).to eq(expected_view)
      end
    end
    context 'submit regist_API' do
      it 'should submit regist' do
        stub = double
        controller = UserController.new

        params = {
          'full_name' => 'martin garrix',
          'username' => 'mGarrix12',
          'email' => 'mGarrix12@gmail.com',
          'password' => 'mGarrix12',
          'conpass' => 'mGarrix12',
          'gender' => 'Male'
        }

        expect(User).to receive(:new).with(params).and_return(stub)
        expect(stub).to receive(:save)

        response = {
          'message' => 'Success',
          'status' => 200,
          'method' => 'POST',
          'data' => params         
        }

        result = controller.register_API(params)
        expect(result.to_json).to eq(response.to_json)
      end
      it 'password & confirmation not same' do
        stub = double
        controller = UserController.new

        params = {
          'full_name' => 'martin garrix',
          'username' => 'mGarrix12',
          'email' => 'mGarrix12@gmail.com',
          'password' => 'mGarrix12',
          'conpass' => 'mGarrix',
          'gender' => 'Male'
        }

        result = controller.registerPage(params, 'submit')
        alert = "Confirm password should be same as password"
        response = {
          'message' => alert,
          'status' => 401,
          'method' => 'POST',
          'data' => params
        }
        result = controller.register_API(params)
        expect(result.to_json).to eq(response.to_json)
      end
      it 'username cannot contain space' do
        stub = double
        controller = UserController.new

        params = {
          'full_name' => 'martin garrix',
          'username' => 'm Garrix12',
          'email' => 'mGarrix12@gmail.com',
          'password' => 'mGarrix12',
          'conpass' => 'mGarrix12',
          'gender' => 'Male'
        }
        alert = "username cannot contain space (' ')"
        response = {
          'message' => alert,
          'status' => 401,
          'method' => 'POST',
          'data' => params
        }
        result = controller.register_API(params)
        expect(result.to_json).to eq(response.to_json)
      end
      it 'username already exist' do
        stub = double
        controller = UserController.new

        params = {
          'full_name' => 'martin garrix',
          'username' => 'diazware12',
          'email' => 'mGarrix12@gmail.com',
          'password' => 'mGarrix12',
          'conpass' => 'mGarrix12',
          'gender' => 'Male'
        }

        alert = "username already used by other user"
        response = {
          'message' => alert,
          'status' => 401,
          'method' => 'POST',
          'data' => params
        }
        result = controller.register_API(params)
        expect(result.to_json).to eq(response.to_json)
      end
    end
  end

  describe 'forgot password' do
    context 'page' do
      it 'should show forgot password page' do
        controller = UserController.new
        params = {}
        result = controller.forgotPassword(params,"page")

        alert = nil
        expected_view = ERB.new(File.read('views/forgotPassword.erb')).result(binding)
        expect(result).to eq(expected_view)
      end
    end
    context 'submit' do
      it 'reset password' do
        stub = double

        controller = UserController.new
        params = {
          'userId' => 1,
          'full_name' => 'Diaz Ilyasa',
          'username' => 'diazware12',
          'email' => 'diazilyasa987@gmail.com',
          'password' => 'diazware12',
          'conpass' => 'diazware12',
          'gender' => 'Male'
        }

        alert = nil
        result = controller.forgotPassword(params,'submit')
        
        expected_view = ERB.new(File.read('views/login.erb')).result(binding)
        expect(result).to eq(expected_view)       
      end
      it 'password & confirmation should be same' do
        stub = double

        controller = UserController.new
        params = {
          'userId' => 1,
          'full_name' => 'Diaz Ilyasa',
          'username' => 'diazware12',
          'email' => 'diazilyasa987@gmail.com',
          'password' => 'diazware12',
          'conpass' => 'foo',
          'gender' => 'Male'
        }

        alert = "Confirm password should be same as password"
        result = controller.forgotPassword(params,'submit')
        
        expected_view = ERB.new(File.read('views/register.erb')).result(binding)
        expect(result).to eq(expected_view)       
      end
      it 'username cannot contains space' do
        stub = double

        controller = UserController.new
        params = {
          'userId' => 1,
          'full_name' => 'Diaz Ilyasa',
          'username' => 'diaz ware12',
          'email' => 'diazilyasa987@gmail.com',
          'password' => 'diazware12',
          'conpass' => 'diazware12',
          'gender' => 'Male'
        }

        alert = "username cannot contain space (' ')"
        result = controller.forgotPassword(params,'submit')
        
        expected_view = ERB.new(File.read('views/register.erb')).result(binding)
        expect(result).to eq(expected_view)       
      end
      it 'username not found' do
        stub = double

        controller = UserController.new
        params = {
          'userId' => 1,
          'full_name' => 'Diaz Ilyasa',
          'username' => 'qux',
          'email' => 'diazilyasa987@gmail.com',
          'password' => 'diazware12',
          'conpass' => 'diazware12',
          'gender' => 'Male'
        }

        alert = "username not found"
        result = controller.forgotPassword(params,'submit')
        
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
