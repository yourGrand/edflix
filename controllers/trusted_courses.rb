require "sinatra"

# trusted_courses.rb
db = SQLite3::Database.new("./db/production.sqlite3")
# GET route for trusted courses
get '/trusted_courses' do
  if session[:logged_in] && (User.getRole(session[:username]) == "Trusted")

    # change the hide status of the course if Hide buitton was pressed
    course = Course[course_id: params[:courseid]]
    if course
        if course.hide_status == 0
            course.update(course_hidden: 1)
        else
            course.update(course_hidden: 0)
        end
    end

    @courses = Course.where(course_trusted: 1).all


    erb :trusted_courses
  else
    redirect '/login'
  end
end
