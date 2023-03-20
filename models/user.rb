class User < Sequel::Model(:login_details)
  def self.login(username, password)
    # Find the user with the given username
    user = User.first(username: username)

    # Return false if the user doesn't exist or the password is incorrect
    return false unless user

    user.password == password
  end

  def self.newUser(username, password, email)
    # Gets most recent login_id
    if User.max(:login_id).nil?
      newID = 0
    else
      newID = User.max(:login_id) + 1
    end

    # Adds user to login_details
    User.insert(login_id: newID, email: email, username: username, password: password)

    true
  end
end
