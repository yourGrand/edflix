require "sinatra"

db = SQLite3::Database.new("./db/test.sqlite3")

# Define a route for the trusted dashboard
get '/dashboard_trusted' do
  # Check if the user is logged in and has the trusted_provider role
  if session[:logged_in]
    erb :dashboard_trusted
  else
    redirect '/login'
  end
end
