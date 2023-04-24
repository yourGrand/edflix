require 'openssl'
require_relative '../db/db'



class User < Sequel::Model(:login_details)

  def self.login(username, password)
    # Find the user with the given username
    user = User.first(username: username)

    # Return false if the user doesn't exist
    return false unless user

    if user.salt && user.iv && user.password_crypt
      # Set up AES for decryption.
      aes = OpenSSL::Cipher.new('AES-128-CBC').decrypt
  
      # Set the IV and key.
      aes.iv = user.iv
      aes.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(password, user.salt, 20_000, 16)
  
      # Try to decrypt the password.
      begin
        decrypted_password = aes.update(user.password_crypt) + aes.final
      rescue OpenSSL::Cipher::CipherError
        return false
      end
  
      # Verify that the decrypted password matches the input password.
      decrypted_password == password
    else
      if user.password == password
        user.update_blank_fields
        return true
      else
        return false
      end
    end
  end

  def self.checkExisting(username, email)
    # Check if any user has the given username or email
    existing_username = User.first(username: username)
    existing_email = User.first(email: email)

    # Return whichever field already exists
    return "user" if existing_username
    return "email" if existing_email

    # If not found return null
    return "null"
  end

  def self.newUser(username, password, email)
    # Set up AES for encryption.
    aes = OpenSSL::Cipher.new('AES-128-CBC').encrypt

    # Generate a random IV.
    iv = Sequel.blob(aes.random_iv)

    # Generate a random salt.
    salt = Sequel.blob(OpenSSL::Random.random_bytes(16))

    # Get the key from the password and salt.
    aes.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(password, salt, 20_000, 16)

    # Encrypt the password.
    password_crypt = Sequel.blob(aes.update(password) + aes.final)


    DB.transaction do
      # Gets most recent login_id
      if User.max(:login_id).nil?
        newID = 0
      else
        newID = User.max(:login_id) + 1
      end

      # Adds user to login_details
      User.insert(login_id: newID, email: email, username: username, password_crypt: password_crypt, iv: iv, salt: salt)

      # Adds user to users table with the same login_id
      UserTable.insert(user_id: newID, role: 4, first_name: "null", surname: "null", gender: 0, date_of_birth: "null", country: 0, degree: 0, course: 1, suspended: 2, login: newID)

      return true
    end
  end

# function for updating the existing user crendentials
  def update_blank_fields
    # Check if salt, iv, and password_crypt fields are blank
    if salt.nil? || iv.nil? || password_crypt.nil?
      # Set up AES for encryption.
      aes = OpenSSL::Cipher.new('AES-128-CBC').encrypt
  
      # Generate a random IV and salt.
      aes.iv = Sequel.blob(aes.random_iv)
      self.salt = Sequel.blob(OpenSSL::Random.random_bytes(16))
  
      # Set the key using PBKDF2.
      aes.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(password, salt, 20_000, 16)
  
      # Encrypt the password using AES.
      self.password_crypt = Sequel.blob(aes.update(password) + aes.final)
  
      # Update the user record.
      save_changes
    end
  end


  def self.getEmail(username)
    #Find user with given username
    user = User.first(username: username)

    #Finds user email
    userEmail = user.email

    return userEmail
  end

  def self.getRole(username)
    # Find the user with the given username
    user = User.first(username: username)
    
    # Get the role associated with the user
    userRole = DB[:users].join(:roles, role_id: :role).where(user_id: user.login_id).first
    
    
    return userRole[:role]
  end

  def self.getNationality(username)
    # Find the user with the given username
    user = User.first(username: username)
    
    # Get the nationality associated with the user
    userNationality = DB[:users].join(:countries, country_id: :country).where(user_id: user.login_id).first
    
    
    return userNationality[:country]
  end

  def self.getCourses(username)
    # Find the user with the given username
    user = User.first(username: username)
    
    # Get the courses associated with the user
    userCourses = DB[:users].join(:courses, course_id: :course).where(user_id: user.login_id).select(:course_title).first
    
    
    return userCourses[:course_title]
  end

  def authenticate(password)
    return self.password == password
  end



  def self.change_password(username, old_password, new_password)
    # Find the user with the given username
    user = User.first(username: username)
  
    # Return false if the user doesn't exist or the password is incorrect
    return false unless user
    return false unless user.authenticate(old_password)
  
    # Set up AES for encryption.
    aes = OpenSSL::Cipher.new('AES-128-CBC').encrypt
  
    # Generate a random IV and salt.
    iv = aes.random_iv
    salt = OpenSSL::Random.random_bytes(16)
  
    # Set the key using PBKDF2.
    aes.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(new_password, salt, 20000, 16)
  
    # Encrypt the new password using AES.
    password_crypt = aes.update(new_password) + aes.final
  
    # Update the user's salt, iv, and password_crypt fields with the new values.
    user.update(salt: salt, iv: iv, password_crypt: password_crypt)
  
    return true
  end
end

class UserTable < Sequel::Model(:users)


end



