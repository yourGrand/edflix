require 'sinatra'
require_relative '../models/user'

# Render the login form
get '/login' do
  if session[:logged_in]
    redirect '/dashboard'
  else
    erb :login
  end
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
  # Attempt to log in the user
  elsif User.login(username, password)
    @dashUsername = username
    @dashEmail = User.getEmail(username)
    @dashRole = User.getRole(username)  
      
    # redirect '/dashboard'
    session[:logged_in] = true
    session[:username] = username
    session[:email] = User.getEmail(username)
    session[:role] = User.getRole(username)
    session[:nationality] = User.getNationality(username)
    session[:courses] = User.getCourses(username)

    if User.getRole(username) == "Learner"
      redirect "/dashboard"

    elsif User.getRole(username) == "Manager"
      redirect "/dashboard_manager"

    elsif User.getRole(username) == "Admin"
      redirect "/dashboard_admin"

    elsif User.getRole(username) == "Moderator"
      redirect "/dashboard_moderator"
    
    elsif User.getRole(username) == "Trusted"
      redirect "/dashboard_trusted"

    else 
      redirect "/dashboard"
        
    # if user is suspended give them an error and do not allow login
    @userID = User.getUserID(username)
    if User.getSuspension(@userID)
      @error = "You are currently suspended from Edflix, please contact us"
      erb :login
    else
      @dashUsername = username
      @dashEmail = User.getEmail(username)
      @dashRole = User.getRole(username)  
  
  
      # redirect '/dashboard'
      session[:logged_in] = true
      session[:username] = username
      session[:email] = User.getEmail(username)
      session[:role] = User.getRole(username)
      session[:nationality] = User.getNationality(username)
      session[:courses] = User.getCourses(username)
  
      if User.getRole(username) == "Learner"
  
        redirect "/dashboard"
  
      elsif User.getRole(username) == "Manager"
  
        redirect "/dashboard_manager"
  
      elsif User.getRole(username) == "Admin"
        redirect "/dashboard_admin"
  
      elsif User.getRole(username) == "Moderator"
        redirect "/dashboard_moderator"
      
      elsif User.getRole(username) == "Trusted"
        redirect "/dashboard_trusted"
  
      else 
        redirect "/dashboard"
      end
    end
  end
    
  else
    @error = "Incorrect username or password"
    erb :login
  end

    
end

get "/logout" do
  session.clear
  erb :login
end
