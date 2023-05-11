require 'sinatra'
require_relative '../models/user'

# Render the change email form
get '/change_email' do
  if session[:logged_in]
    erb :change_email
  else
    redirect '/login'
  end
end
# Handle the email change form submission
post '/change_email' do
  username = session[:username]
  old_email = params['old_email']
  new_email = params['new_email']
  confirm_email = params['confirm_email']

  # Check if the old email is correct
  if User.authenticateEmail(username, old_email)
    # Check if new email is valid and available
    if new_email.include?("@") == false || new_email.include?(".") == false
      @error = "Please enter a valid E-mail (example@example.com)" 
      erb :change_email
    else
      if User.checkExisting(username, new_email) == "pass"
        @error = "That E-mail is already in use"
        erb :change_email
      else
        # Check if the new email and confirm email match
        if new_email == confirm_email
          # Change the user's email
          User.change_email(username, old_email, new_email)
          redirect '/dashboard'
        else
          @error = "New email and confirm email do not match"
          erb :change_email
        end
      end
    end
  else
    @error = "Incorrect old email"
    erb :change_email
  end
end
