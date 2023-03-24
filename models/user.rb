class User < Sequel::Model(:login_details)
  def self.login(username, password)
    # Find the user with the given username
    user = User.first(username: username)

    # Return false if the user doesn't exist or the password is incorrect
    return false unless user

    user.password == password
  end

  def self.checkExisting(username, email)
    # Check if any user has the given username, password, or email
    existing_username = User.first(username: username)
    existing_email = User.first(email: email)

    # Return whichever field already exists
    return "user" if existing_username
    return "email" if existing_email

    # If not found return null
    return "null"
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

  def self.change_password(username, old_password, new_password)
    # Find the user with the given username
    user = User.first(username: username)

    # Return false if the user doesn't exist or the password is incorrect
    return false unless user && user.password == old_password

    # Update the user's password in the database
    user.update(password: new_password)

    true
  end
end

class UserTable < Sequel::Model(:users)
end
