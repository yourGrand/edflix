require "sinatra"

# Define a route for the trusted dashboard
get '/dashboard_trusted' do
  # Check if the user is logged in and has the trusted_provider role
  if session[:logged_in]
    if session[:role] == 'Trusted'
      @dashUsername = session[:username]
      @dashEmail = session[:email]
      @dashRole = session[:role]
      @dashNationality = session[:nationality]
      @dashCourses = session[:courses]
      erb :dashboard_trusted
    else
      erb :dashboard
    end
  else
    redirect '/login'
  end
end
