require 'sinatra'
require_relative '../models/user'


# Render the login form
get '/login' do
  erb :login
end

# Handle the login form submission
post "/login" do
  username = params["username"]
  password = params["password"]

  # Check if the username or password is empty
  if username.empty? && password.empty?
    @error = "Please enter both username and password"
    erb :login
  elsif username.empty?
    @error = "Please enter your username"
    erb :login
  elsif password.empty?
    @error = "Please enter your password"
    erb :login
  else
    # Attempt to log in the user
    if User.login(username, password)
      "Welcome, #{username}!"
      erb :dashboard
    else
      @error = "Incorrect username or password"
      erb :login
    end
  end
end
