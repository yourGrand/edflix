require "sinatra"

# trusted_courses.rb
db = SQLite3::Database.new("./db/test.sqlite3")
# GET route for trusted courses
get '/trusted_courses' do
  if session[:logged_in] && (User.getRole(session[:username]) == "Trusted")

    @courses = Course.where(course_trusted: 1).all


    erb :trusted_courses
  else
    redirect '/login'
  end
end
