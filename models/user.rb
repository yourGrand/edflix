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

  def self.newUser(username, password, email,trusted_provider)
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

    # Set trusted_provider to 1 if checked, 0 otherwise
    trusted_provider = trusted_provider ? 1 : 0


    DB.transaction do
      # Gets most recent login_id
      if User.max(:login_id).nil?
        newID = 0
      else
        newID = User.max(:login_id) + 1
      end

      # Adds user to login_details
      User.insert(login_id: newID, email: email, username: username, password_crypt: password_crypt, iv: iv, salt: salt,trusted_provider: trusted_provider)

      # Adds user to users table with the same login_id
      UserTable.insert(user_id: newID, role: 4, first_name: "null", surname: "null", gender: 0, date_of_birth: "null", region: 0, degree: 0, course: 1, suspended: 2, login: newID)

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

  def self.getUsername(userID)
    #Find user with given id
    login_details = User.first(login_id: userID)

    #Finds username
    if login_details
      username = login_details[:username]
      return username
    else
      return nil
    end

  end

  def self.getEmail(username)
    #Find user with given username
    login_details = User.first(username: username)

    #Finds username
    if login_details
      userEmail = login_details[:email]
      return userEmail
    else
      return nil
    end
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
    userNationality = DB[:users].join(:regions, region_id: :region).where(user_id: user.login_id).first
    
    
    return userNationality[:region]
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
  
  
  def self.updateDetails(userID, first_name, surname, gender, date_of_birth, region, degree)
# >>>>>>> 172442da56a08bef4b96433daf2cd75f78f155f4
    user = UserTable.first(user_id: userID)
    user.update(first_name: first_name, surname: surname, gender: gender, date_of_birth: date_of_birth, region: region, degree: degree)
    return true
  end

  def self.adminUpdate(userID, username, email, first_name, surname, gender, date_of_birth, region, degree, suspended)

    if first_name != ""
      DB[:users].where(user_id: userID).update(first_name: first_name)
    end

    if surname != ""
      DB[:users].where(user_id: userID).update(surname: surname)
    end

    if gender != ""
      DB[:users].where(user_id: userID).update(gender: gender)
    end

    if date_of_birth != ""
      DB[:users].where(user_id: userID).update(date_of_birth: date_of_birth)
    end

    if region != ""
      DB[:users].where(user_id: userID).update(region: region)
    end

    if degree != ""
      DB[:users].where(user_id: userID).update(degree: degree)
    end

    if suspended != ""
      DB[:users].where(user_id: userID).update(suspended: suspended)
    end

    if username != ""
      DB[:login_details].where(login_id: userID).update(username: username)
    end

    if email != ""
      DB[:login_details].where(login_id: userID).update(email: email)
    end

    true
  end

  def self.getUserID(username)
    #Find user with given username
    user = User.first(username: username)

    #Finds user ID
    userID = user[:login_id]

    return userID
  end

  def self.getFirstName(userID)
    # Find the user with the given user ID
    user = DB[:users].first(user_id: userID)
    
    # Get the first name of the user
    if user
      userFirstName = user[:first_name]
      return userFirstName
    else
      return nil
    end
  end

  def self.getSurname(userID)
    # Find the user with the given user ID
    user = DB[:users].first(user_id: userID)
    
    # Get the surname of the user
    if user
      userSurname = user[:surname]
      return userSurname
    else
      return nil
    end
  end
  
  def self.getGender(userID)
    # Find the user with the given user ID
    user = DB[:users].where(user_id: userID).select(:gender).first
 
    # Get the gender associated with the user
    userGender = DB[:users].join(:genders, gender_id: :gender).where(user_id: userID).first
    
    return userGender[:gender]
  end

  def self.getDateOfBirth(userID)
    # Find the user with the given user ID
    user = DB[:users].where(user_id: userID).select(:date_of_birth).first

    
    # Get the date of birth of the user
    if user
      userDateOfBirth = user[:date_of_birth]
      return userDateOfBirth
    else
      return nil
    end
  end

  def self.getRegion(userID)
    # Find the user with the given user ID
    user = DB[:users].where(user_id: userID).select(:region).first
 
    # Get the nationality associated with the user
    userRegion = DB[:users].join(:regions, region_id: :region).where(user_id: userID).first
    
    return userRegion[:region]
  end


  def self.getDegree(userID)
    # Find the user with the given user ID
    user = DB[:users].where(user_id: userID).select(:degree).first
 
    # Get the degree level associated with the user
    userDegree = DB[:users].join(:degrees, degree_id: :degree).where(user_id: userID).first
    
    return userDegree[:degree]
  end
  

  def self.getCourse(userID)
    # Find the user with the given user ID
    user = DB[:users].where(user_id: userID).select(:course).first
 
    # Get the course associated with the user
    userCourse = DB[:users].join(:courses, course_id: :course).where(user_id: userID).first
    
    return userCourse[:course_title]
  end

  def self.change_email(username, old_email, new_email)
    # Find the user with the given username
    user = User.first(username: username)
  
    # Return false if the user doesn't exist
    return false unless user
  

    # Update the user's email
    user.update(email: new_email)
  
    return true
  end

  def self.authenticateEmail(username, email)
    user = User.first(username: username)
    return user.email == email
  end

end

class UserTable < Sequel::Model(:users)


end



