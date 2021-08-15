require './db/db_connector'

class User
    attr_reader :userId, :full_name, :username, :email, :password, :gender, :profile_pic, :role, :dtm_crt, :description

    def initialize (params)
        @userId = params[:userId]
        @full_name = params[:full_name]
        @username = params[:username]
        @email = params[:email]
        @password = params[:password]
        @gender = params[:gender]
        @profile_pic = params[:profile_pic]
        @role = params[:role]
        @dtm_crt = params[:dtm_crt]
        @description = params[:description]
    end

    def self.getUser(username,password)
        client = create_db_client
        rawData=client.query("""
                select * from users
                where username = '#{username}' and password = '#{password}'
            """)
        user = nil
        rawData.each do |data|
            user = User.new(
                userId: data["userId"],
                full_name: data["full_name"],
                username: data["username"],
                email: data["email"],
                password: data["password"],
                gender: data["gender"],
                profile_pic: data["profile_pic"],
                role: data["role"],
                dtm_crt: data["dtm_crt"]
            )
        end
        user
    end

    def self.getUserById(id)
        client = create_db_client
        rawData=client.query("""
                select * from users
                where userId = #{id}
            """)
        user = nil
        rawData.each do |data|
            user = User.new(
                userId: data["userId"],
                full_name: data["full_name"],
                username: data["username"],
                email: data["email"],
                password: data["password"],
                gender: data["gender"],
                profile_pic: data["profile_pic"],
                role: data["role"],
                dtm_crt: data["dtm_crt"],
                description: data["description"]
            )
        end
        user
    end

    def self.userList
        client = create_db_client
        rawData=client.query("""
                select * from users
            """)
        userList = Array.new
        rawData.each do |data|
            user = User.new(
                userId: data["userId"],
                full_name: data["full_name"],
                username: data["username"],
                email: data["email"],
                password: data["password"],
                gender: data["gender"],
                profile_pic: data["profile_pic"],
                role: data["role"],
                dtm_crt: data["dtm_crt"]
            )
            userList.push(user)
        end
        userList
    end

    def self.searchUser(search)
        client = create_db_client
        rawData=client.query("""
                select * from users
                where username like '%#{search}%'
                or full_name like '%#{search}%'
            """)
        userList = Array.new
        rawData.each do |data|
            user = User.new(
                userId: data["userId"],
                full_name: data["full_name"],
                username: data["username"],
                email: data["email"],
                password: data["password"],
                gender: data["gender"],
                profile_pic: data["profile_pic"],
                role: data["role"],
                dtm_crt: data["dtm_crt"]
            )
            userList.push(user)
        end
        userList
    end

    def update
        return false unless valid? 
        client = create_db_client
        rawData=client.query("""
            UPDATE users
            SET 
                username = '#{@username}',
                full_name = '#{@full_name}',
                description = '#{@description}'
            WHERE userId = #{@userId} 
        
        """) 
    end

    def updateProfilePic
        return false unless valid? 
        client = create_db_client
        rawData=client.query("""
            UPDATE users
            SET 
                profile_pic = '/transaction/#{profile_pic}'
            WHERE userId = #{@userId} 
        """) 
    end

    def valid?
        return false if @full_name.nil?
        return false if @username.nil?
        return false if @email.nil?
        return true
    end
end