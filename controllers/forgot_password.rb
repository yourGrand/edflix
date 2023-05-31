require 'securerandom'
require_relative '../models/user'
require 'sinatra'

# Route for the reset password page
get '/forgot_password' do
    erb :forgot_password
  end
  
# Route for processing the reset password form
post '/forgot_password' do
  email = params[:email]
  username = params[:username]
  
  # Validate the inputs
  if email.empty? || username.empty?
    @error = "Please enter your email and username."
    erb :forgot_password
  end
  
  # Find the user
  user = User.first(email: email, username: username)
  if !user
    @error = "No user found with that email and username."
    erb :forgot_password
  end

  if user.nil?
    @error = "username not found"
    redirect '/forgot_password'
  end
  
  # Generate a new password and update the user's password
  new_password = SecureRandom.hex(8)
  User.change_password(username, user.password, new_password)
  
  # Render the display password page with the new password
  @new_password = new_password
  erb :display_password
end
  
  
