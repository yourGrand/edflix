require 'sinatra'
require_relative '../models/user'

get '/change_password' do
  if session[:logged_in]
    erb :change_password
  else
    redirect '/login'
  end
end


# Handle the password change form submission
post '/change_password' do
  username = session[:username]
  old_password = params['old_password']
  new_password = params['new_password']
  confirm_password = params['confirm_password']

  # puts "Username: #{username}"

  # Check if the old password is correct
  if User.login(username, old_password)
    # Check if the new password and confirm password match
    if new_password == confirm_password
      # Change the user's password
      User.change_password(username, old_password, new_password)
      redirect '/dashboard'
    else
      @error = "New password and confirm password do not match"
      erb :change_password
    end
  else
    @error = "Incorrect old password"
    erb :change_password
  end
end
