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
end
