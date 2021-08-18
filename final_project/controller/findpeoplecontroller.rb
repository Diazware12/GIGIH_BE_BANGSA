require './model/user'
require_relative 'generalcontroller'

class FindPeopleController
  def findPeople(params)
    getUser = User.getUserById(params['userId'])

    peopleList = nil
    peopleList = if !params['searchUser'].nil?
                   User.searchUser(params['searchUser'])
                 else
                   User.userList
                 end
    renderer = ERB.new(File.read('views/findpeople.erb'))
    renderer.result(binding)
  end
  
  #API Test
  def findPeople_API(params)
    getUser = User.getUserById(params['userId'])

    return {
      'message' => 'user not found',
      'status' => 401,
      'method' => 'POST',
      'data' => params
    }if GeneralController.checkNil(getUser) == true

    peoples = nil
    peoples = if !params['searchUser'].nil?
                   User.searchUser(params['searchUser'])
                 else
                   User.userList
                 end
    
    results = []
    
    peoples.each do |people|
      results.push({
        'userId': people.userId,
        'full_name': people.full_name,
        'username': people.username,
        'email': people.email,
        'password': people.password,
        'gender': people.gender,
        'profile_pic': people.profile_pic,
        'role': people.role,
        'dtm_crt': people.dtm_crt,
      })
    end

    {
      'message' => 'Success',
      'status' => 200,
      'method' => 'POST',
      'data' => {
        "Current Log-In User" => {
          "full_name": getUser.full_name,
          "username": getUser.username,
          "email": getUser.email,
          "password": getUser.password,
          "gender": getUser.gender
        },
        'users' => results  
      }
    }
  end
end
