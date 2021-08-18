require './model/user'

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
end
