class User < Sequel::Model
  def self.login(username, password)
    # Find the user with the given username
    user = User.first(username: username)

    # Return false if the user doesn't exist or the password is incorrect
    return false unless user
    user.password == password
  end

    # Return true to indicate success
    true
end

