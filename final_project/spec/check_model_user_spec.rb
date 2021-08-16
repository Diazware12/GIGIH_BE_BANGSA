require_relative '../model/user'
require_relative '../db/db_connector'
require 'mysql2'

describe User do

    # =================== valid initialize =====================

    describe '#validUser' do
        context 'true' do
            it 'should be true' do
                user = User.new(
                    userId: 1,
                    full_name: "Lord Aldebaran",
                    username: "aldi23",
                    email: "Aldi23@gmail.com",
                    password: "aldi23",
                    gender: "Male",
                    profile_pic: "/transaction/foo.jpg",
                    role: "user",
                    dtm_crt: "2020-12-23",
                    description: "random"
                )
                expect(user.valid?).to eq(true)
            end
        end 
        context 'false' do
            it 'should be false' do
                user = User.new(
                    userId: 1,
                    full_name: "Lord Aldebaran",
                    email: "Aldi23@gmail.com",
                    password: "aldi23",
                    gender: "Male",
                    profile_pic: "/transaction/foo.jpg",
                    role: "user",
                    dtm_crt: "2020-12-23",
                    description: "random"
                )
                expect(user.valid?).to eq(false)
            end
        end 

    end

    # =================== save data =====================

    describe 'save' do
        context 'when executed' do
            it 'should save data' do
                stub_client = double
                stub_query = "insert into users (full_name,username,email,password,gender,role,dtm_crt) values ('Aldebaran Adi','aldi123','aldi123@gmail.com','aldi123','Male','User',curdate())"

                getUser = User.new(
                    full_name: "Aldebaran Adi",
                    username: "aldi123",
                    email: "aldi123@gmail.com",
                    password: "aldi123",
                    gender: "Male"
                )
                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query)
                getUser.save
            end
        end
    end

    # =================== update data =====================

    describe 'update' do
        context 'update data' do
            it 'should update data' do
                stub_client = double
                stub_query = "UPDATE users SET username = 'aldi123',full_name = 'Aldebaran Adi',email = 'aldi123@gmail.com',description = 'only for testing purposes' WHERE userId = 1 "
        

                getUser = User.new(
                    userId: 1,
                    full_name: "Aldebaran Adi",
                    username: "aldi123",
                    email: "aldi123@gmail.com",
                    description: "only for testing purposes"
                )
                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query)
                getUser.update

            end
        end
        context 'forget password' do
            it 'should update data' do
                stub_client = double
                stub_query = "UPDATE users SET password = 'equinox' WHERE userId = 1"
        

                getUser = User.new(
                    userId: 1,
                    full_name: "Aldebaran Adi",
                    username: "aldi123",
                    email: "aldi123@gmail.com",
                    password: "equinox"
                )
                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query)
                getUser.updatePassword

            end
        end
    end

    describe 'update profile picture' do
        context 'update profpic' do
            it 'should update data' do
                stub_client = double
                stub_query = "UPDATE users SET profile_pic = '/transaction/aldi123.jpg' WHERE userId = 1 "
        
                getUser = User.new(
                    userId: 1,
                    full_name: "Aldebaran Adi",
                    username: "aldi123",
                    email: "aldi123@gmail.com",
                    profile_pic: "aldi123.jpg"
                )
                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query)
                getUser.updateProfilePic

            end
        end
    end

    # =================== Login User =====================

    describe 'Login User' do
        context 'true' do
            it 'there\'s a data' do
                stub_client = double
                stub_query = "select * from users where username = 'mGrix99' and password = 'mGrix99'"
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

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query).and_return(users)

                user = User.getUser("mGrix99","mGrix99")
                expect(user).not_to be_nil
            end
        end

        context 'false' do
            it 'there\'s no data' do
                stub_client = double
                stub_query = "select * from users where username = 'mGrix99' and password = 'mGrix99'"
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

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query).and_return([])

                user = User.getUser("mGrix99","mGrix99")
                expect(user).to eq(nil)
            end
        end

    end

    # =================== select data =====================

    describe 'Get User By User Id' do
        context 'true' do
            it 'there\'s a data' do
                stub_client = double
                stub_query = "select * from users where userId = 1"
                users = [{
                    "userId": 1, 
                    "full_name": "Martin Garrix", 
                    "username": "mGrix99", 
                    "email": "mGrix99@gmail.com", 
                    "password": "mGrix99",
                    "gender": "Male", 
                    "profile_pic": "/transaction/1-mGrix99.jpg", 
                    "role": "User",
                    "dtm_crt": "2021-08-12",
                    "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod", 
                }]

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query).and_return(users)

                user = User.getUserById(1)
                expect(user).not_to be_nil
            end
        end

        context 'false' do
            it 'there\'s no data' do
                stub_client = double
                stub_query = "select * from users where userId = 1"
                users = [{
                    "userId": 1, 
                    "full_name": "Martin Garrix", 
                    "username": "mGrix99", 
                    "email": "mGrix99@gmail.com", 
                    "password": "mGrix99",
                    "gender": "Male", 
                    "profile_pic": "/transaction/1-mGrix99.jpg", 
                    "role": "User",
                    "dtm_crt": "2021-08-12",
                    "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod", 
                }]

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query).and_return([])

                user = User.getUserById(1)
                expect(user).to eq(nil)
            end
        end

    end

    describe 'Get User By User Name (for edit password)' do
        context 'true' do
            it 'there\'s a data' do
                stub_client = double
                stub_query = "select * from users where username = 'mGrix99'"
                users = [{
                    "userId": 1, 
                    "full_name": "Martin Garrix", 
                    "username": "mGrix99", 
                    "email": "mGrix99@gmail.com", 
                    "password": "mGrix99",
                    "gender": "Male", 
                    "profile_pic": "/transaction/1-mGrix99.jpg", 
                    "role": "User",
                    "dtm_crt": "2021-08-12",
                    "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod", 
                }]

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query).and_return(users)

                user = User.getUserByName('mGrix99')
                expect(user).not_to be_nil
            end
        end

        context 'false' do
            it 'there\'s no data' do
                stub_client = double
                stub_query = "select * from users where username = 'mGrix99'"
                users = [{
                    "userId": 1, 
                    "full_name": "Martin Garrix", 
                    "username": "mGrix99", 
                    "email": "mGrix99@gmail.com", 
                    "password": "mGrix99",
                    "gender": "Male", 
                    "profile_pic": "/transaction/1-mGrix99.jpg", 
                    "role": "User",
                    "dtm_crt": "2021-08-12",
                    "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod", 
                }]

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query).and_return([])

                user = User.getUserByName('mGrix99')
                expect(user).to eq(nil)
            end
        end

    end

    describe 'Get all User Data' do
        context 'get all data' do
            it 'there\'s a data' do
                stub_client = double
                stub_query = "select * from users"
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

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query).and_return(users)

                user = User.userList
                expect(user).not_to be_nil
            end
        end
    end

    describe 'Search User' do
        context 'true' do
            it 'there\'s a data' do
                stub_client = double
                stub_query = "select * from users where username like '%mGrix99%' or full_name like '%mGrix99%'"
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

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query).and_return(users)

                user = User.searchUser('mGrix99')
                expect(user).not_to be_nil
            end
        end

        context 'false' do
            it 'there\'s no data' do
                stub_client = double
                stub_query = "select * from users where username like '%mGrix99%' or full_name like '%mGrix99%'"
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

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query).and_return([])

                user = User.searchUser('mGrix99')
                expect(user).to eq([])
            end
        end

    end

end
