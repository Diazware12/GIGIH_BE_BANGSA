require './model/user'

class FindPeopleController
    def findPeople(params)

        getUser = User.getUserById(params['usId'])

        peopleList = nil
        if params['searchUser'] != nil
            peopleList = User.searchUser(params['searchUser'])
        else    
            peopleList = User.userList
        end 
        renderer = ERB.new(File.read("views/findpeople.erb"))
        renderer.result(binding)  
    end


end