class User < Sequel::Model(:login_details)
  def self.login(username, password)
    # Find the user with the given username
    user = User.first(username: username)

    # Return false if the user doesn't exist or the password is incorrect
    return false unless user

    user.password == password
  end

  def self.newUser(username, password, email)
  

    DB.transaction do

      # Gets most recent login_id
      if User.max(:login_id).nil?
        newID = 0
      else
        newID = User.max(:login_id) + 1
      end
  
      # Adds user to login_details
      User.insert(login_id: newID, email: email, username: username, password: password)
  
      # Adds user to users table with the same login_id
      UserTable.insert(user_id: newID, role: 4, first_name: "null", surname: "null", gender: 0, date_of_birth: "null", country: 0, degree: 0, course: 1, suspended: 2, login: newID)
      
      # THIS WILL NOT WORK AS ALL FIELDS IN users ARE FOREIGN KEYS AND HAVE FOREIGN KEY CONSTRAINTS
      # see here: https://www.w3schools.com/sql/sql_foreignkey.asp

      return true
  
    end
  
  


  end

  def self.getEmail(username)
    #Find user with given username
    user = User.first(username: username)

    #Finds user email
    userEmail = user.email

    return userEmail
  end
end

class UserTable < Sequel::Model(:users)
end
